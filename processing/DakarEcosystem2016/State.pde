/// Represents the current state of a StateParticle.
abstract class State {

  StateParticle parent;

  State() {}

  StateParticle getParent() { return parent; }
  void setParent(StateParticle parent) {
    if (parent != this.parent)
    {
      if (this.parent != null)
        exit();
      this.parent = parent;
      enter();
    }
  }

  void enter() {}
  State react(BWorld world) { return this; }
  void exit() {}

  void addForce(Vec2D force) {
    parent.addForce(force);
  }

  void addBehavior(ParticleBehavior2D behavior) {
    parent.addBehavior(behavior);
  }

  abstract void draw();

  abstract String getType();
}
