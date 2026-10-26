Table table;

void setup() {
  size(900, 600);
  background(245, 245, 240); 
  
  // get data
  table = loadTable("music_data.csv", "header");
  println("Total tracks loaded: " + table.getRowCount()); // check if working
  
  noLoop(); // stop it repeating
}

void draw() {
  // title
  fill(0);
  textSize(20);
  text("Dear Data: Music Scrobbles", 40, 40);

  // grid layout stuff
  int startX = 60;
  int startY = 80;
  int spacingX = 80;
  int spacingY = 70;
  int columns = 10;

  for (int i = 0; i < table.getRowCount(); i++) {
    TableRow row = table.getRow(i);
    String genre = row.getString("genre");
    String activity = row.getString("activity");

    // pos
    int x = startX + (i % columns) * spacingX;
    int y = startY + (i / columns) * spacingY;

    // base dot
    fill(getGenreColor(genre));
    noStroke();
    ellipse(x, y, 24, 24);

    // activity shapes
    stroke(0);
    strokeWeight(2);
    if (activity.equals("Gaming")) {
      // cross mark
      line(x - 7, y - 7, x + 7, y + 7);
      line(x - 7, y + 7, x + 7, y - 7);
    } else if (activity.equals("Uni/studying")) {
      line(x, y - 12, x, y - 18); // line on top
    } else if (activity.equals("Commuting to uni/work")) {
      line(x - 14, y, x + 14, y); // horizontal bar
    } else if (activity.equals("Asleep")) {
      point(x, y);
    }
  }

  // legend
  drawSimpleLegend();
}

// returns color value for criteria
color getGenreColor(String genre) {
  if (genre.contains("Pop")) {
    return color(245, 175, 65);  // yellow-ish
  } else if (genre.contains("Rock")) {
    return color(230, 80, 70);
  } else if (genre.contains("R&B") || genre.contains("Soul")) {
    return color(155, 95, 185); // purple
  } else if (genre.contains("Hip-Hop") || genre.contains("Rap")) {
    return color(70, 150, 210);  // blue
  } else {
    return color(150); // fallback grey
  }
}

void drawSimpleLegend() {
  fill(0);
  textSize(12);
  text("Legend:", 40, 520);
  
  // colors key
  noStroke();
  fill(245, 175, 65); ellipse(110, 516, 12, 12);
  fill(0); text("Pop", 125, 520);

  fill(230, 80, 70); ellipse(180, 516, 12, 12);
  fill(0); text("Rock", 195, 520);

  fill(155, 95, 185); ellipse(250, 516, 12, 12);
  fill(0); text("R&B", 265, 520);

  fill(70, 150, 210); ellipse(320, 516, 12, 12);
  fill(0); text("Hip-Hop", 335, 520);

  // activities key
  stroke(0);
  strokeWeight(2);
  line(410, 512, 420, 522); line(410, 522, 420, 512);
  fill(0); text("Gaming", 428, 520);

  line(500, 512, 500, 522);
  fill(0); text("Study", 508, 520);

  line(570, 517, 585, 517);
  fill(0); text("Commute", 593, 520);
}