public class Robot {

  PShape base, shoulder, upArm, loArm, end;
  float alpha = 0, beta = 0, gamma = 0;

  int iterator = 0;
  float xlp = 0, ylp = 0, zlp = 0;
  int currentMillis = 0, previousMillis = 0, interval = 3000;

  public Robot(PShape base_, PShape shoulder_, PShape upArm_, PShape loArm_, PShape end_) {
    base = base_;
    shoulder = shoulder_;
    upArm = upArm_;
    loArm = loArm_;
    end = end_;

    // Disable shape styles to ensure proper rendering
    shoulder.disableStyle();
    upArm.disableStyle();
    loArm.disableStyle();
    end.disableStyle();
  }

  void IK(float x, float y, float z) {
    int lenShoulder = 15;
    int lenArm = 50;

    // Fixes the offset of the shoulder of the model
    y = y - lenShoulder;

    float l = sqrt(x*x + z*z);
    float h = sqrt(l*l + y*y);
    float phi = atan(y/l);
    float theta = acos((h/2)/lenArm);

    // Calculation of the gamma angle responsible for the rotation of the robot around the y-axis
    gamma = atan2(-x, -z);
    // Calculation of the alpha angle of the shoulder
    alpha = phi + theta;
    // Calculation of the beta angle of the low arm without the offset of alpha
    beta = phi - theta - alpha;
  }

  // Interpolate the path of the robot's end effector
  void pathInterp(int spotWidth, int spotHeight, int spotDepth, ArrayList <Spot> path) {
    currentMillis = millis();
    xlp = lerp(xlp, path.get(iterator).x * spotWidth, 0.05);
    ylp = lerp(ylp, path.get(iterator).y * spotHeight, 0.05);
    zlp = lerp(zlp, path.get(iterator).z * spotDepth, 0.05);
    robot.IK(xlp, ylp, zlp);

    if (currentMillis - previousMillis >= interval) {
      if (iterator == path.size()-1) {
        iterator = 0;
      } else {
        iterator++;
      }
      previousMillis = currentMillis;
    }
  }

  void show() {
    noStroke();
    fill(#FFE308);

    push();

    // Base
    shape(base);
    translate(0, 4, 0);

    // Shoulder
    rotateY(gamma);
    shape(shoulder);

    // Upper arm
    translate(0, 25, 0);
    rotateY(PI);
    rotateX(-1*alpha);
    shape(upArm);

    // Lower arm
    translate(0, 0, 50);
    rotateY(PI);
    rotateX(beta);
    shape(loArm);

    // End effector
    translate(0, 0, -50);
    rotateY(PI);
    rotateX(PI/2+alpha+beta);
    shape(end);

    pop();
  }
}
