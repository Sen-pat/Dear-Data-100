# Dear Data 100

This repository contains my progress on the Dear Data project, where I am collecting and visualizing personal data using Processing. 

For my topic, I decided to track my daily music listening habits alongside the activities I was doing at the time. The goal is to see how different music choices match up with daily routines like studying, travelling, relaxing, or gaming.

### Data Collection & Source

The listening data was tracked using Last.fm, which is connected directly to my Spotify account to automatically scrobble every track I play. Because Last.fm logs the track title, artist, album, and precise timestamp, I was able to export this history and manually tag each entry with the corresponding activity I was engaged in when the song was playing, as well as its general musical genre.

All the processed data is stored in `DearDataSketch/data/music_data.csv`. Each entry records the following information:

* **timestamp**: The date and exact time the song was scrobbled via Last.fm.
* **artist**: The musician, band, or creator of the track.
* **track**: The title of the song.
* **album**: The album or release the track belongs to.
* **genre**: The general musical genre (e.g., Pop, Rock, R&B, Hip-Hop).
* **activity**: The main activity taking place during listening (such as studying, gaming, commuting, or sleeping).

### Project Layout

The repository is organized following the standard Processing sketchbook structure:

* `README.md` provides documentation and general context for the project.
* `DearDataSketch/` contains the source code for the sketch (`DearDataSketch.pde`).
* `DearDataSketch/data/` holds the dataset (`music_data.csv`) so Processing can automatically load it using `loadTable()`.

### Current Progress

The dataset has been built up incrementally across separate commits to keep a record of collection progress. The sketch is currently set up to load the data file, parse the columns, and test out simple ways to visually represent each song and activity on screen.