ArrayList<ScrobbleGlyph> glyphs = new ArrayList<ScrobbleGlyph>();
String activeFilter = "ALL"; // Press keys 1-5 to filter by activity

void setup() {
  size(1000, 680);
  smooth();
  
  Table table = loadTable("music_data.csv", "header");
  
  int cols = 13;
  float startX = 65;
  float startY = 95;
  float spacingX = 72;
  float spacingY = 48;
  
  // Instantiate objects of the ScrobbleGlyph class
  for (int i = 0; i < table.getRowCount(); i++) {
    TableRow row = table.getRow(i);
    
    int col = i % cols;
    int rowIdx = i / cols;
    float x = startX + col * spacingX;
    float y = startY + rowIdx * spacingY;
    
    ScrobbleGlyph g = new ScrobbleGlyph(
      x, y,
      row.getString("timestamp"),
      row.getString("artist"),
      row.getString("track"),
      row.getString("genre"),
      row.getString("activity")
    );
    glyphs.add(g);
  }
}

void draw() {
  background(247, 244, 237); // Warm postcard paper tone
  drawHeader();
  
  ScrobbleGlyph hovered = null;
  
  // Display all glyph objects
  for (ScrobbleGlyph g : glyphs) {
    boolean dimmed = !activeFilter.equals("ALL") && !g.activity.equals(activeFilter);
    g.display(dimmed);
    
    if (g.isMouseOver()) {
      hovered = g;
    }
  }
  
  drawLegend();
  
  // Draw interactive tooltip on top if hovering over an object
  if (hovered != null) {
    hovered.drawTooltip();
  }
}

void drawHeader() {
  fill(30);
  textAlign(LEFT, BASELINE);
  textSize(20);
  text("DEAR DATA 100: PERSONAL AUDIO STREAM (" + glyphs.size() + " SCROBBLES)", 50, 42);
  
  textSize(12);
  fill(95);
  text("Hover over any glyph for track details  |  Filter keys: [1] All   [2] Gaming   [3] Studying   [4] Commuting   [5] Asleep", 50, 64);
}

void drawLegend() {
  float ly = 605;
  textAlign(LEFT, CENTER);
  textSize(12);
  fill(40);
  text("GENRE (Color):", 50, ly);
  
  noStroke();
  fill(245, 175, 65); ellipse(160, ly, 12, 12); fill(50); text("Pop", 172, ly);
  fill(230, 80, 70);  ellipse(225, ly, 12, 12); fill(50); text("Rock", 237, ly);
  fill(155, 95, 185); ellipse(295, ly, 12, 12); fill(50); text("R&B / Soul", 307, ly);
  fill(70, 150, 210); ellipse(395, ly, 12, 12); fill(50); text("Hip-Hop / Rap", 407, ly);
  fill(145);          ellipse(515, ly, 12, 12); fill(50); text("Other", 527, ly);
  
  float ay = 640;
  fill(40);
  text("ACTIVITY (Shape):", 50, ay);
  
  stroke(40);
  strokeWeight(1.8);
  noFill();
  
  // Gaming X
  line(175, ay - 5, 185, ay + 5);
  line(175, ay + 5, 185, ay - 5);
  fill(50); noStroke(); text("Gaming", 193, ay);
  
  // Study vertical antenna + dot
  stroke(40); line(270, ay + 6, 270, ay - 6); ellipse(270, ay - 8, 3, 3);
  fill(50); noStroke(); text("Uni / Studying", 280, ay);
  
  // Commute horizontal transit bar
  stroke(40); line(390, ay, 408, ay);
  fill(50); noStroke(); text("Commuting", 415, ay);
  
  // Asleep crescent arc
  stroke(40); noFill(); arc(515, ay, 14, 14, radians(40), radians(220));
  fill(50); noStroke(); text("Asleep", 528, ay);
}

void keyPressed() {
  if (key == '1') activeFilter = "ALL";
  else if (key == '2') activeFilter = "Gaming";
  else if (key == '3') activeFilter = "Uni/studying";
  else if (key == '4') activeFilter = "Commuting to uni/work";
  else if (key == '5') activeFilter = "Asleep";
}

// =========================================================================
// CODING REQUIREMENT: Custom Class representing a single music scrobble
// =========================================================================
class ScrobbleGlyph {
  float x, y;
  float baseRadius = 22;
  String timestamp, artist, track, genre, activity;
  color genreColor;
  int hourOfDay;

  // Constructor
  ScrobbleGlyph(float x, float y, String timestamp, String artist, String track, String genre, String activity) {
    this.x = x;
    this.y = y;
    this.timestamp = timestamp;
    this.artist = artist;
    this.track = track;
    this.genre = genre;
    this.activity = activity;
    this.genreColor = computeGenreColor(genre);
    
    // Extract hour from "YYYY-MM-DD HH:MM" to encode time of day visually
    String[] parts = split(timestamp, " ");
    if (parts.length > 1) {
      String[] timeParts = split(parts[1], ":");
      this.hourOfDay = int(timeParts[0]);
    }
  }

  color computeGenreColor(String g) {
    if (g.contains("Pop")) return color(245, 175, 65);
    if (g.contains("Rock")) return color(230, 80, 70);
    if (g.contains("R&B") || g.contains("Soul")) return color(155, 95, 185);
    if (g.contains("Hip-Hop") || g.contains("Rap") || g.contains("Trap")) return color(70, 150, 210);
    return color(145);
  }

  boolean isMouseOver() {
    return dist(mouseX, mouseY, x, y) < baseRadius * 0.7;
  }

  void display(boolean dimmed) {
    pushMatrix();
    translate(x, y);
    
    float alpha = dimmed ? 45 : 255;
    float d = isMouseOver() ? baseRadius * 1.35 : baseRadius;

    // 1. Outer time-of-day ring (subtle halo for late-night listening after 8 PM)
    if (hourOfDay >= 20 || hourOfDay <= 6) {
      noFill();
      stroke(60, alpha * 0.45);
      strokeWeight(1.2);
      ellipse(0, 0, d + 8, d + 8);
    }

    // 2. Main Genre Circle
    fill(red(genreColor), green(genreColor), blue(genreColor), alpha);
    noStroke();
    ellipse(0, 0, d, d);

    // 3. Activity Symbol Overlay
    stroke(30, alpha);
    strokeWeight(1.8);
    noFill();
    if (activity.equals("Gaming")) {
      line(-6, -6, 6, 6);
      line(-6, 6, 6, -6);
    } else if (activity.equals("Uni/studying")) {
      line(0, -11, 0, -18);
      ellipse(0, -20, 2.5, 2.5);
    } else if (activity.equals("Commuting to uni/work")) {
      line(-14, 0, 14, 0);
    } else if (activity.equals("Asleep")) {
      arc(0, 0, 14, 14, radians(40), radians(220));
    }
    
    popMatrix();
  }

  void drawTooltip() {
    String line1 = track + " - " + artist;
    String line2 = genre + "  |  " + activity + " (" + timestamp + ")";
    
    textSize(12);
    float boxW = max(textWidth(line1), textWidth(line2)) + 24;
    float boxH = 46;
    
    // Keep tooltip inside screen bounds
    float tx = constrain(x + 15, 20, width - boxW - 20);
    float ty = constrain(y - 55, 20, height - boxH - 20);
    
    fill(30, 235);
    noStroke();
    rect(tx, ty, boxW, boxH, 6);
    
    fill(255);
    textAlign(LEFT, TOP);
    text(line1, tx + 12, ty + 8);
    
    fill(200);
    textSize(11);
    text(line2, tx + 12, ty + 25);
  }
}