public class A_star3D {
  // Open Set -> Vector containing nodes to explore
  ArrayList<Spot> openSet = new ArrayList<Spot>();
  // Close Set -> Vector containing explored nodes
  ArrayList<Spot> closeSet = new ArrayList<Spot>();
  // Path
  ArrayList<Spot> path = new ArrayList<Spot>();
  // Obstacles
  ArrayList<Spot> obstacles = new ArrayList<Spot>();

  // Flag to terminate the algorithm
  boolean flagFinnish = false;

  // Initial Node
  Spot start;
  // Target Node (Final)
  Spot target;

  public A_star3D(int xstart, int ystart, int zstart, int xend, int yend, int zend, int cols, int rows, int aisle) {
    // Map of the world
    Spot grid[][][] = new Spot[cols + 2][rows + 2][aisle + 2];

    // Offset to center the grid
    int xoffset = -cols/2;
    // Offset to push the grid forward (in direction of the camera)
    int zoffset = 3;

    // Create the grid with spots
    int x = xoffset;
    for (int i = 0; i <= cols + 1; i++) {
      int y = 0;
      for (int j = 0; j <= rows + 1; j++) {
        int z = zoffset;
        for (int k = 0; k <= aisle + 1; k++) {
          if (x == xoffset || y == 0 || z == zoffset || x == cols + 1 + xoffset || y == rows + 1 || z == aisle + 1 + zoffset) {
            // Defines the value as null as it is a border
            grid[i][j][k] = null;
          } else {
            grid[i][j][k] = new Spot(x, y, z);
            if (grid[i][j][k].wall == true) {
              obstacles.add(grid[i][j][k]);
            }
          }
          z++;
        }
        y++;
      }
      x++;
    }

    // Determine neighbors for each Spot
    for (int i = 1; i <= cols; i++) {
      for (int j = 1; j <= rows; j++) {
        for (int k = 1; k <= aisle; k++) {
          if (grid[i][j][k] != null) {
            grid[i][j][k].addNeighbors(i, j, k, grid);
          }
        }
      }
    }

    // Assume the initial point defined by xstart, ystart and zstart
    start = grid[xstart][ystart][zstart];
    // Assume the target point defined by xend, yend, zend
    target = grid[xend][yend][zend];

    obstacles.remove(start);
    obstacles.remove(target);

    openSet.add(start);
  }

  ArrayList<Spot> pathCalc() {
    while (!flagFinnish) {
      if (openSet.isEmpty()) {
        println("No solution exists!");

        // Activate the finnishing flag
        flagFinnish = true;
        break;
      }

      int winner = 0; // Assume the start of the openSet is always the best node

      // If a spot in the openSet has a lower 'f', the winner is updated
      for (int i = 0; i < openSet.size(); i++) {
        if (openSet.get(winner).f > openSet.get(i).f) {
          winner = i;
        }
      }

      Spot current = openSet.get(winner);

      if (current == target) { // If the current spot is the target, the algorithm has finnished
        println("Reached the end!");

        // Add to the path all the spots that con
        path.add(current);
        while (current.parent != null) {
          path.add(current.parent);
          current = current.parent;
        }

        // Activate the finnishing flag
        flagFinnish = true;
      } else {
        // Add the current spot to the closeSet
        openSet.remove(current);
        closeSet.add(current);

        // Calculates the 'n', 'h' and 'f' values for the neighboring values
        // Also, if one of the current neighbors has already been analyzed, but the new path
        // calculates lower values for its values, it is updated
        ArrayList<Spot> neighbors = current.Neighbors;
        for (Spot n : neighbors) {
          if (n != null && !closeSet.contains(n) && !obstacles.contains(n)) {
            float tempG = current.g + 1;
            if (!openSet.contains(n) || tempG < n.g) {
              n.g = tempG;
              n.parent = current;
              n.h = heuristic(n, target);
              n.f = n.g + n.h;

              if (!openSet.contains(n)) {
                openSet.add(n);
              }
            }
          }
        }
      }
    }
    return path;
  }

  float heuristic(Spot neighbor, Spot target) {
    // Calculate Manhattan distance as heuristic
    float manhDistance = abs(neighbor.x - target.x) + abs(neighbor.y - target.y) + abs(neighbor.z - target.z);
    return manhDistance;
  }

  void show(int spotWidth, int spotHeight, int spotDepth, int keyIndex) {

    switch (keyIndex) {
    case 49:
      // Show obstacles
      for (Spot obst : obstacles) {
        obst.show(255, 255, 255, spotWidth, spotHeight, spotDepth, 50);
      }
      break;
    case 50:
      // Show closeSet
      for (Spot c : closeSet) {
        c.show(255, 0, 0, spotWidth, spotHeight, spotDepth, 50);
      }
      break;
    case 51:
      // Show openSet
      for (Spot o : openSet) {
        o.show(0, 255, 0, spotWidth, spotHeight, spotDepth, 50);
      }
      break;
    default:
      // Show path
      for (Spot p : path) {
        p.show(0, 0, 255, spotWidth, spotHeight, spotDepth, 255);
      }
      start.show(255, 0, 0, spotWidth, spotHeight, spotDepth, 255);
      target.show(0, 255, 0, spotWidth, spotHeight, spotDepth, 255);
      break;
    }
  }
}
