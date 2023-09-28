public class Spot {
  // Coordinates in 3D space
  int x = 0, y = 0, z = 0;

  // Costs for pathfinding algorithms
  float f = 0, h = 0, g = 0;

  // Indicates if this spot is an obstacle
  boolean wall = false;

  // List to store neighboring spots
  ArrayList<Spot> Neighbors = new ArrayList<Spot>();

  // Parent spot used for path reconstruction
  Spot parent = null;

  // Constructor for a spot object with coordinates x_, y_, and z_
  public Spot(int x_, int y_, int z_) {
    x = x_;
    y = y_;
    z = z_;

    // Randomly determine if this spot is an obstacle (20% chance)
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

  // Add neighboring spots to the neighbors ArrayList
  void addNeighbors(int xindex, int yindex, int zindex, Spot grid[][][]) {
    // Loop through the 3D neighborhood around the current spot
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        for (int k = -1; k <= 1; k++) {
          boolean isNotCurrentSpot = (i != 0 || j != 0 || k != 0); // Check if it's not the current spot
          boolean isWithinBounds = (xindex + i >= 0 && yindex + j >= 0 && zindex + k >= 0 // Check if the neighboring spot is within the grid bounds
            && xindex + i < grid.length && yindex + j < grid[0].length && zindex + k < grid[0][0].length);
          if (isNotCurrentSpot && isWithinBounds) {
            // Add the neighboring spot to the neighbors ArrayList
            Neighbors.add(grid[xindex + i][yindex + j][zindex + k]);
          }
        }
      }
    }
  }
}
