//trailball

makeParticles(integer link, string color1, string color2)
{
   //vector particleOmega = <0.0,0.0,0.0>;
   systemSafeSet = systemAge;
   integer flags = 
      PSYS_PART_EMISSIVE_MASK |
      PSYS_PART_INTERP_COLOR_MASK |
      PSYS_PART_INTERP_SCALE_MASK |
      PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;
   //PSYS_PART_FOLLOW_SRC_MASK ? maybe...
   list particles = [
   PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
   PSYS_SRC_BURST_RADIUS,      0.3,
   PSYS_SRC_ANGLE_BEGIN,       PI/30,
   PSYS_SRC_ANGLE_END,         0,
   PSYS_PART_START_COLOR,      (vector)color1,
   PSYS_PART_END_COLOR,        (vector)color2,
   PSYS_PART_START_ALPHA,      1.0,
   PSYS_PART_END_ALPHA,        0.3,
   PSYS_PART_START_SCALE,      <1.0,1.0,0.0>,
   PSYS_PART_END_SCALE,        <3.0,3.0,0.0>,
   PSYS_SRC_TEXTURE,           texture,
   PSYS_SRC_MAX_AGE,           systemSafeSet,
   PSYS_PART_MAX_AGE,          5.0,
   PSYS_SRC_BURST_RATE,        0.02,
   PSYS_SRC_BURST_PART_COUNT,  10.0,
   PSYS_SRC_ACCEL,             <0.0,0.0,-2.0>,
   PSYS_SRC_OMEGA,             particleOmega,
   PSYS_SRC_BURST_SPEED_MIN,   (partSpeed * 1.2),
   PSYS_SRC_BURST_SPEED_MAX,   (partSpeed * 1.4),
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}
