# The London Django Meetup Group

The official Github repo of The London Django Meetup Group.

View the site at
[http://www.djangolondon.com](http://www.djangolondon.com).

## Contribution

Please share by sending through a Pull Request. All constructive contributions
are very welcome. Please let us know if we've made a mistake or an omission by
opening an Issue.


## Running the site locally

This site is built with Jekyll and hosted on Github Pages. They have [an
excellent guide for testing the site locally]
(https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/)
that should get you set up.

## Quickly fire up project with Docker

Make sure you've got the latest version of Docker and docker-compose.

Just run `docker-compose up -d` to get started.

The app will be served at `http://127.0.0.1:4000/`, the slides for the meetup will be at `/organizers/2018-06-25/`.

## Auto-build on save and live-reload

Jekyll can build the site static files automatically as the source files are updated. To run Jekyll in auto-building mode run `guard -i`, alternatively just run `jekyll serve`.

The Docker instance runs with auto-build enabled by default.

If you want to manually build the project run `jekyll build` or if using Docker `docker-compose run app jekyll build`

Live-reload is supported in this project, this means that, as the project is updated, you don't have to constantly refresh the browser window.

To enable live-reloading in your browser [install the appropriate extension for your browser](http://livereload.com/extensions/#installing-sections)

## YouTube videos

We record our online meetups with Zoom and upload the talks to our YouTube channel.
Here’s the process for creating a video from a Zoom recording.

**First,** crop out the talk using with [`ffmpeg`](https://ffmpeg.org/).
You can use a version of this command:

```
ffmpeg -ss 15:52 -to 1:16:36 -i zoom_0.mp4 -filter:a loudnorm -ar 44100 -c:v copy making-your-own-magic.mp4
```

* `-ss` selects the start time.
  Aim for when the speaker says something like "okay, I'll begin now".

* `-to` selects the end time.
  Cut after the Q&A is finished.

* `-i` names the input video.
  This is normally `zoom_0.mp4`, in the local folder that Zoom creates.

* `-filter:a loudnorm` normalizes the audio level, so our videos have a sensible volume.

* `-c:v copy` copies the video data, without re-encoding it.
  This is fast.
  Note that a keyframe may be missing at the start of the video so when you play it back locally it might look rubbish for a few seconds.
  Don’t worry about that—YouTube fixes it for us.

* Select an output video name matching the title of the talk in kebab-case.
  This name is used on Otter.ai, at least.

**Second,** upload the video to YouTube, and add a description matching the others.
Set the video language to English, and save it as “unlisted”.

**Third,** extract the audio from the video.
This can also be done with `ffmpeg`, using a command like this:

```
ffmpeg -i dictionaries-behind-the-scenes.mp4 -codec:a copy dictionaries-behind-the-scenes.aac
```

This copies out the audio channel separately.

**Fourth,** upload the audio to Otter.ai.
It will automatically transcribe the audio.

**Fifth,** manually correct the transcription on Otter.ai.
This is the most tedious step.
The transcription is probably about 80-90% correct, but it can be severely wrong, especially on technical terms.
It needs fixing

Use the Otter.ai Edit mode to step through and correct one paragraph at a time.
Check out its shortcut keys to make things a little easier.

There’s no built-in way of tracking progress, but there’s a way to fake it.
Otter guesses speakers per paragraph, which is normally correct.
But if you manually select a speaker for a paragraph (which requires unselecting first), then it will show a green check mark on that paragraph.
Do this for each paragraph after you manually correct it, and it can be used to track progress.

Even going quickly, it can take 2-3 minutes to correct the transcription of a minute of audio.

It might be worth adding repeatedly wrong words to the custom vocabulary page: https://blog.otter.ai/custom-vocabulary/ .
This won’t be used to re-transcribe the current conversation, unless you delete and reupload it.
But it will help future uploads.

**Six,** download the Otter subtitle file.
This is under “...” -> “Export Text”, and select SRT with the default options.
Then moves the Otter conversation into the “Done” folder.

**Seven,** attach the subtitles to the YouTube video.

**Eight,** contact the speaker to ask them to “okay” the video.

**Nine,** publish the video, and tweet about it from our Twitter account.

### Blanking the screen for a segment

If a speaker accidentally shows private information, such as their email inbox, we can black out the screen in the video before uploading it to YouTube.
This can be done with another ffmpeg command:

```
ffmpeg -i talk.mp4 -f lavfi -i "color=black:s=1920x1200:r=25" -filter_complex \
"[0:v][1]overlay=enable='between(t,1333,1339)'[video]" \
-map "[video]" -map 0:a:0 -c:a copy -to 30:20 talk-blanked.mp4
```

* `-f lavfi` enables generating a video stream inside ffmpeg.

* `-i "color=black:s=1920x1200:r=25"` generates a stream representing a black screen.
  The resolution and framerate (`r=`) must match the input video.

* The multiline `-filter_complex` arguament.
  The `between()` value selects the start and end in seconds where black overlay will appear.

* The `-map` arguments select what will be output.

* `-c:a copy` copies the audio from the original video without re-encoding it.
  Unfortunately re-encoding the video required with this setup, so it will lose some quality.

* `-to` should specify the length of the original video.
  This stops ffmpeg generating an infinite length video, since the overlay stream is infinite.

Multiple blankings can be done by specifying a more complex filter.
See [the original stack exchange question](https://superuser.com/questions/1094343/replace-parts-of-video-with-another-video-with-ffmpeg).
