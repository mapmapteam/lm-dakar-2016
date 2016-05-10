class StateButterfly extends StateAgent {

  StateButterfly() {
    setFlockStrength(5);
  }

  void enter() {
  }

  State react(BWorld world) {
    //parent.addForce(steer(new Vec2D(width/2, height/2), true));
    if (random(1) < 0.0001)
      return new StateTrash();
    else
    {
      if (parent.y() >= world.getWorldBounds().getBottom()-20)
        addForce(new Vec2D(0, -5));
      else
        addForce(new Vec2D(0, -0.1));
      flock( world.getParticlesWithType("state:butterfly"));

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
