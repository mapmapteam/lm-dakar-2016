/**
 * This class is the physics engine that contains everything. It also provides
 * a set of methods to get observations of the world for the agents.
 */
class BWorld extends VerletPhysics2D {

  ArrayList<BParticle> bParticles;

  ConstantForceBehavior constant;

  BWorld() {
    bParticles = new ArrayList<BParticle>();
  }

  void init(int pixelOffset) {
    // Set bounds.
    setWorldBounds(new Rect(pixelOffset, pixelOffset, width-2*pixelOffset, height-2*pixelOffset));
//    setWorldBounds(bounds);
    setDrag(0.05f);
    constant = new ConstantForceBehavior(new Vec2D());

    addBehavior(constant);
  }

  VerletPhysics2D addParticle(VerletParticle2D p) {
    if (p instanceof BParticle)
      return addBParticle((BParticle)p);
    else
      return super.addParticle(p);
  }

  BWorld addBParticle(BParticle p) {
    bParticles.add(p);
    return (BWorld)super.addParticle(p);
  }

  VerletPhysics2D update() {
    // Call the react function of particles.
    for (BParticle p : bParticles) {
        p.react(this);
    }

    // Update all.
    return super.update();
  }

  void draw() {
    // Call the react function of particles.
    for (BParticle p : bParticles) {
      p.draw();
    }
  }

  ArrayList<BParticle> getAllBParticles() {
    return bParticles;
  }

  ArrayList<VerletParticle2D> getParticlesWithType(String type) {
    ArrayList<VerletParticle2D> ret = new ArrayList<VerletParticle2D>();
    for (BParticle p : bParticles) {
      if (p.getType().equals(type))
        ret.add(p);
    }
    return ret;
  }

  void setConstantForce(Vec2D force) {
    constant.setForce(force);
  }

}
