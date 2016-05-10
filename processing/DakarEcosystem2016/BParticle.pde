///
abstract class BParticle extends VerletParticle2D {

  BParticle(Vec2D position) {
    super(position);
  }

  /// Adds all necessary forces to react to the world.
  abstract void react(BWorld world);

  /// Draw the particle.
  abstract void draw();

  /// Get the type of particle.
  abstract String getType();
}
