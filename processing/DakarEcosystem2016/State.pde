/// Represents the current state of a StateParticle.
abstract class State {

  StateParticle parent;

  State() {}

  StateParticle getParent() { return parent; }
  void setParent(StateParticle parent) {
    this.parent = parent;
    enter();
  }

  void enter() {}
  State react(BWorld world) { return this; }
  void exit() {}

  abstract void draw();

  abstract String getType();
}
