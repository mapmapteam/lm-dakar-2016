import toxi.physics2d.behaviors.ParticleBehavior2D;
import toxi.geom.Vec2D;
import toxi.physics2d.VerletParticle2D;
import processing.core.PApplet;

public class SeekBehavior implements ParticleBehavior2D {

  static final float MAX_FORCE = 0.05f;
  protected Vec2D target;
  protected float attrStrength;

  protected float radius, radiusSquared;
  protected float strength;
  protected float timeStep;

  PApplet applet;

  public SeekBehavior(PApplet applet, Vec2D target, float radius, float strength) {
    this.target = target;
    this.strength = strength;
    setRadius(radius);
    this.applet = applet;
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  Vec2D steer(VerletParticle2D p, boolean slowdown) {
    Vec2D steer;  // The steering vector
    Vec2D desired = target.sub(p);  // A vector pointing from the location to the target
    float d = desired.magnitude(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      //desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if (slowdown && d < 100.0f) desired.normalizeTo(attrStrength*d/100.0f); // This damping is somewhat arbitrary
      else desired.normalizeTo(attrStrength);
      // Steering = Desired minus Velocity
      steer = desired.sub(p.getVelocity());  // Limit to maximum steering force
      steer.limit(MAX_FORCE);
      //steer = desired;
    }
    else {
      steer = new Vec2D();
    }

    applet.println(p.getVelocity().heading() + " " + p.getVelocity().magnitude());
    applet.println(steer);

    return steer;
  }

  public void apply(VerletParticle2D p) {
    p.addForce(steer(p, false));
  }

  // public void applyWithIndex(SpatialIndex<Vec2D> spaceHash) {
  //   List<Vec2D> selection = spaceHash.itemsWithinRadius(attractor, radius, null);
  //   final Vec2D temp = new Vec2D();
  //   if (selection != null) {
  //     for (Vec2D p : selection) {
  //       temp.set(p);
  //       apply((VerletParticle2D) p);
  //       spaceHash.reindex(temp, p);
  //     }
  //   }
  // }

  public void configure(float timeStep) {
    this.timeStep = timeStep;
    setStrength(strength);
  }

  /**
  * @return the target
  */
  public Vec2D getTarget() {
    return target;
  }

  /**
  * @return the radius
  */
  public float getRadius() {
    return radius;
  }

  /**
  * @return the strength
  */
  public float getStrength() {
    return strength;
  }

  /**
  * @param attractor
  *            the attractor to set
  */
  public void setTarget(Vec2D target) {
    this.target = target;
  }

  public void setRadius(float r) {
    this.radius = r;
    this.radiusSquared = r * r;
  }

  /**
  * @param strength
  *            the strength to set
  */
  public void setStrength(float strength) {
    this.strength = strength;
    this.attrStrength = strength * timeStep;
  }

  public boolean supportsSpatialIndex() {
//    return true;
    return false;
  }

}
