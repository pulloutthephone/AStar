public class Spot {
  int x = 0, y = 0, z = 0;

  float f = 0, h = 0, g = 0;

  boolean wall = false;

  ArrayList<Spot> Neighbors = new ArrayList<Spot>();
  
  Spot parent = null;

  // Constructor for a Spot object with coordinates x_, y_, and z_
  public Spot(int x_, int y_, int z_) {
    x = x_;
    y = y_;
    z = z_;

    // Randomly determine if this Spot is an obstacle (20% chance)
    if (random(0, 1) < 0.2) {
      wall = true;
    }
  }

  // Display the Spot as a box with specified color and dimensions
  void show(int R, int G, int B, float nW, float nH, float nD, float alpha) {
    stroke(0);
    fill(R, G, B, alpha);
    push();
    translate(x * nW, y * nH, z * nD);
    box(nW, nH, nD);
    pop();
  }

  // Add neighboring Spots to the Neighbors ArrayList
  void addNeighbors(int xindex, int yindex, int zindex, Spot grid[][][]) {
    // Loop through the 3D neighborhood around the current Spot
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        for (int k = -1; k <= 1; k++) {
          // Skip the current Spot itself (i=0, j=0, k=0)
          if (i != 0 || j != 0 || k != 0) {
            // Add the neighboring Spot to the Neighbors ArrayList
            Neighbors.add(grid[xindex + i][yindex + j][zindex + k]);
          }
        }
      }
    }
  }
}
