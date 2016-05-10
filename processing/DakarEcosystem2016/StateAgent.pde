abstract class StateAgent extends State {

  static protected final float STEER_MAX_FORCE = 0.1f;
  static protected final float STEER_SLOWDOWN_THRESHOLD = 100.0f;
  float steerStrength = 100;

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  Vec2D steer(Vec2D target, boolean slowdown) {
    Vec2D steer;  // The steering vector
    Vec2D desired = target.sub(parent);  // A vector pointing from the location to the target
    float d = desired.magnitude(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- steerStrength)
      if (slowdown && d < STEER_SLOWDOWN_THRESHOLD) desired.normalizeTo(steerStrength*d/STEER_SLOWDOWN_THRESHOLD); // This damping is somewhat arbitrary
      else desired.normalizeTo(steerStrength);
      // Steering = Desired minus Velocity
      steer = desired.sub(parent.getVelocity());  // Limit to maximum steering force
      steer.limit(STEER_MAX_FORCE);
    }
    else {
      steer = new Vec2D();
    }

    return steer;
  }

  void seek(Vec2D target) {
    parent.addForce(steer(target, false));
  }

  void arrive(Vec2D target) {
    parent.addForce(steer(target, true));
  }

  boolean lineRepulse(Line2D line, float strength, float minDistance) {
    Vec2D desired = parent.sub(line.closestPointTo(parent));
    float d = desired.magnitude();
    if (d < minDistance)
      addForce(desired.normalizeTo(strength));
    return (d > 0);
  }

  // Separation
  // Method checks for nearby boids and steers away
  Vec2D separate (ArrayList<VerletParticle2D> boids) {
    float desiredseparation = 25.0f;
    Vec2D steer = new Vec2D();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (VerletParticle2D other : boids) {
      float d = parent.distanceTo(other);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        Vec2D diff = parent.sub(other);
        diff.normalizeTo(1.0/d);
        steer.addSelf(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.magnitude() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalizeTo(steerStrength);
      steer.subSelf(parent.getVelocity());
      steer.limit(STEER_MAX_FORCE);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  Vec2D align (ArrayList<VerletParticle2D> boids) {
    float neighbordist = 50.0;
    Vec2D steer = new Vec2D();
    int count = 0;
    for (VerletParticle2D other : boids) {
      float d = parent.distanceTo(other);
      if ((d > 0) && (d < neighbordist)) {
        steer.addSelf(other.getVelocity());
        count++;
      }
    }
    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.magnitude() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalizeTo(steerStrength);
      steer.subSelf(parent.getVelocity());
      steer.limit(STEER_MAX_FORCE);
    }
    return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  Vec2D cohesion (ArrayList<VerletParticle2D> boids) {
    float neighbordist = 50.0;
    Vec2D sum = new Vec2D();   // Start with empty vector to accumulate all locations
    int count = 0;
    for (VerletParticle2D other : boids) {
      float d = parent.distanceTo(other);
      if ((d > 0) && (d < neighbordist)) {
        sum.addSelf(other); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1.0/count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<VerletParticle2D> boids, float separateWeight, float alignWeight, float cohesionWeight) {
    Vec2D sep = separate(boids);   // Separation
    Vec2D ali = align(boids);      // Alignment
    Vec2D coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.scaleSelf(separateWeight);
    ali.scaleSelf(alignWeight);
    coh.scaleSelf(cohesionWeight);
    // Add the force vectors to acceleration
    parent.addForce(sep);
    parent.addForce(ali);
    parent.addForce(coh);
  }
}
