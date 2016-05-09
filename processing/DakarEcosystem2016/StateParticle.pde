/// A particle that can change state.
class StateParticle extends BParticle {

  final float WEIGHT_SCALE_FACTOR = 10.0f;

  State currentState;

  StateParticle(Vec2D position, State startState) {
    super(position);
    setState(startState);
  }

  void setState(State state) {
    currentState = state;
    currentState.setParent(this);
  }

  State getState() { return currentState; }

  String getType() { return "state:" + currentState.getType(); }

  void react(BWorld world) {
    // Ask for state reaction and get next state.
    State state = currentState.react(world);
    if (state != currentState)
      currentState.exit();
    setState(state);
  }

  void draw() {
    pushMatrix();
    translate(x(), y());
    TestDakarJetDeau.this.scale(getWeight() * WEIGHT_SCALE_FACTOR);
    TestDakarJetDeau.this.rotate(getVelocity().heading() + radians(270));
    currentState.draw();
    popMatrix();
  }
}
