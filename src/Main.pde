// Imports the PeasyCam library //<>//
// Note: Please install the PeasyCam library in Sketch -> Import Library -> Manage Libraries, otherwise the program won't run
import peasy.*;

// Declare a PeasyCam object for camera control
PeasyCam cam;

// Declare an A_star3D object for A* pathfinding
A_star3D aStar;

// Declare a Robot object
Robot robot;

// Initialize a variable to store the ASCII value of the last pressed key
int keyIndex = 52;

void setup() {
  // Set up the canvas size with 3D rendering
  size(1200, 600, P3D);

  // Initialize the camera with PeasyCam
  cam = new PeasyCam(this, 200); // Initializes the cam object
  cam.rotateY(PI); // Rotates the camera PI radians to be in front of the A* grid

  // Create the A_star3D object
  int cols = 10, rows = 10, aisle = 10; // Dimensions of the grid
  int xstart = 1, ystart = 1, zstart = 1, xend = cols, yend = rows, zend = aisle; // Positions of the start and target spots
  // Note: Ensure that the values of xstart, ystart, zstart, xend, yend, and zend
  // fall within the valid intervals: x -> [1, cols], y -> [1, rows], z -> [1, aisle]
  aStar = new A_star3D(xstart, ystart, zstart, xend, yend, zend, cols, rows, aisle); // Initializes the aStar object

  // Import robot parts as PShape objects
  PShape base, shoulder, upArm, loArm, end;
  base = loadShape("r5.obj");
  shoulder = loadShape("r1.obj");
  upArm = loadShape("r2.obj");
  loArm = loadShape("r3.obj");
  end = loadShape("r4.obj");

  // Create the Robot object
  robot = new Robot(base, shoulder, upArm, loArm, end); // Initializes the robot object
}

void draw() {
  // Set up the canvas
  setupCanvas();

  // Size of the spots
  int spotWidth = 5, spotHeigth = 5, spotDepth = 5;

  // Show the path, grid, and lists using A_star3D
  aStar.show(spotWidth, spotHeigth, spotDepth, keyIndex);

  // Calculate and interpolate the robot's path and display it
  robot.pathInterp(spotWidth, spotHeigth, spotDepth, aStar.pathCalc());
  robot.show();
}

void setupCanvas() {
  background(32); // Set background color
  smooth(); // Enable antialiasing
  lights(); // Enable lighting
  directionalLight(51, 102, 126, -1, 0, 0); // Add a directional light source
  scale(-1); // Scale the scene to mirror it horizontally
}

void keyPressed() {
  keyIndex = key; // Store the ASCII value of the last pressed key
}
