class StateTrash extends State {

  State react(BWorld world) {
    if (random(1) < 0.001)
      return new StateButterfly();
    else
      return this;
  }

  void draw() {
    fill(200, 128, 23);
    ellipse(0, 0, 1, 1);
/*    stroke(0);
    strokeWeight(0.1);
    line(0, 0, 0, 1);
    noStroke();*/
  }

  String getType() { return "trash"; }

}
