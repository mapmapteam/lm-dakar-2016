/**
 * This class is the physics engine that contains everything. It also provides
 * a set of methods to get observations of the world for the agents.
 */
class BWorld extends VerletPhysics2D {

  ArrayList<BParticle> bParticles;

  BWorld() {
    bParticles = new ArrayList<BParticle>();
  }

  void init(Rect bounds) {
    // Set bounds.
    setWorldBounds(bounds);
    setDrag(0.05f);
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
}
