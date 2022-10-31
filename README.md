# idedit 

## I worked on this project before i realized how capable ffmpeg was

### ffmpeg command
My current ffmpeg command to do this is: 
`ffmpeg -i in.mp3 -i in.jpg -map 0:a -map 1:0  -id3v2_version 4 -metadata title='title' -metadata artist='artist' -metadata album='album' -metadata date='date' -metadata genre='genre' out.mp3`

This is a simple webserver with one route as a wrapper around id3tag shard
It uses kemal for routing 

schema:

post: /edit/
```
image: binary
file: binary
artist: string
year: string
genre: string
title: string
album: string
```

port can be set by passing -p flag: `idedit -p 4000`
port default is 3000

It has limited error handling and will return 404 if the route params passed are incorredt 

it expects all parameters to be present

```crystal 
params = {
  'image' => image_binary,
  'file' => mp3_binary,
  'artist' => artist_string,
  'year' => year_string,
  'genre' => genre_string,
  'title' => title_string,
  'album' => album_string,
}
```

response body is the binary mp3 file

Ruby query: 

```ruby
file = File.open('test.jpg', 'rb')
mp3_file = File.open('test.mp3', 'rb')
image = file.read
mp3 = mp3_file.read

params = {
  'image' => image,
  'file' => mp3,
  'artist' => "artist name",
  'year' => "year",
  'genre' => "genre",
  'title' => "song title",
  'album' => "album name",
}

uri = URI('http://localhost:3000')
res = Net::HTTP.post_form(uri, params)
File.write("#{title_string}.mp3", res.body)
```
