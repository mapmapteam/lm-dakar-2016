class StateButterfly extends StateAgent {

  float separateWeight, alignWeight, cohesionWeight;

  StateButterfly() {
    separateWeight = 1.0f;
    alignWeight    = 1.0f;
    cohesionWeight = 1.0f;
  }

  void enter() {
  }

  State react(BWorld world) {
    //parent.addForce(steer(new Vec2D(width/2, height/2), true));
    if (random(1) < 0.0001)
      return new StateTrash();
    else
    {
      
      flock( world.getParticlesWithType("state:butterfly"), separateWeight, alignWeight, cohesionWeight);

      return this;
    }
  }

  void draw() {
    fill(255, 200, 200);
    ellipse(0, 0, 1, 1);
    stroke(0);
    strokeWeight(0.1);
    line(0, 0, 0, 1);
    noStroke();
  }

  String getType() { return "butterfly"; }

}
