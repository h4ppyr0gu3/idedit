require "kemal"
require "id3tag"

post "/" do |request|
  begin
    title = request.params.body["title"] #TIT2
    album = request.params.body["album"] # TALB
    artist = request.params.body["artist"] # TPE1 TPE2
    year = request.params.body["year"] # TYER
    genre = request.params.body["genre"] # TCON
    image = request.params.body["image"] # APIC
    file = request.params.body["file"]

    output = title
    image_file = "#{title}_image.jpg"

    File.write(output, file.to_slice, perm = 0o666, mode = "w+")
    File.write(image_file, image.to_slice, perm = 0o666, mode = "w+")

    mp3_file = File.open(output)
    tsse = Id3tag::Read.new(mp3_file).read_tag("TSSE")

    tag_hash = {
      "TIT2": title,
      "TALB": album,
      "TPE1": artist,
      "TPE2": artist,
      "TYER": year,
      "TCON": genre,
      "TSSE": tsse.to_s,
      "APIC": "./#{image_file}",
    }
    
    Id3tag::Write.new(mp3_file).overwrite(tag_hash, output)

    send_file request, "#{output}.mp3", "audio/mp3"

    [ output, image_file, "#{output}.mp3" ].each do |path|
      File.delete(path) if File.exists?(path)
    end

  rescue 
    Log.info { "Failure" }
    request.response.status_code = 404
  end
end
Kemal.config.env = "production"
Kemal.run
