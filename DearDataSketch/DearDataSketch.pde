Table table;

void setup() {
  size(900, 600);
  background(245, 245, 240); // bg color
  
  // get data
  table = loadTable("music_data.csv", "header");
  println("Total tracks loaded: " + table.getRowCount());
  
  noLoop(); // stop it repeating
}

void draw() {
  // title
  fill(0);
  textSize(20);
  text("Dear Data: Music Scrobbles (" + table.getRowCount() + " Items)", 40, 38);

  // grid layout stuff
  int startX = 55;
  int startY = 75;
  int spacingX = 90;
  int spacingY = 42;
  int columns = 13;

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
    ellipse(x, y, 20, 20);

    // activity shapes
    stroke(0);
    strokeWeight(1.8);
    if (activity.equals("Gaming")) {
      // cross mark
      line(x - 6, y - 6, x + 6, y + 6);
      line(x - 6, y + 6, x + 6, y - 6);
    } else if (activity.equals("Uni/studying")) {
      line(x, y - 10, x, y - 16); // line on top
    } else if (activity.equals("Commuting to uni/work")) {
      line(x - 12, y, x + 12, y); // horizontal bar
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
  text("Legend:", 40, 530);
  
  // colors key
  noStroke();
  fill(245, 175, 65); ellipse(110, 526, 12, 12);
  fill(0); text("Pop", 125, 530);

  fill(230, 80, 70); ellipse(180, 526, 12, 12);
  fill(0); text("Rock", 195, 530);

  fill(155, 95, 185); ellipse(250, 526, 12, 12);
  fill(0); text("R&B", 265, 530);

  fill(70, 150, 210); ellipse(320, 526, 12, 12);
  fill(0); text("Hip-Hop", 335, 530);

  // activities key
  stroke(0);
  strokeWeight(1.8);
  line(410, 522, 420, 532); line(410, 532, 420, 522);
  fill(0); text("Gaming", 428, 530);

  line(500, 522, 500, 532);
  fill(0); text("Study", 508, 530);

  line(570, 527, 585, 527);
  fill(0); text("Commute", 593, 530);
}