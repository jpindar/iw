// first starburst bracelets
makeParticles(integer link, string color1, string color2)
{
   //"bda1445f-0e59-4328-901b-a6335932179b"
   systemSafeSet = systemAge;
   integer flags = 
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK |
   PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;
   list particles = [
   PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
   PSYS_SRC_BURST_RADIUS,0.1,
   PSYS_SRC_ANGLE_BEGIN,0,
   PSYS_SRC_ANGLE_END,0,
   PSYS_SRC_TARGET_KEY,llGetKey(),
   PSYS_PART_START_COLOR,      (vector)color1,
   PSYS_PART_END_COLOR,        (vector)color2,
   PSYS_PART_START_ALPHA,1,
   PSYS_PART_END_ALPHA,1,
   PSYS_PART_START_GLOW,0.3,
   PSYS_PART_END_GLOW,0,
   PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
   PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
   PSYS_PART_START_SCALE,<0.200000,0.200000,0.000000>,
   PSYS_PART_END_SCALE,<0.200000,0.200000,0.000000>,
   PSYS_SRC_TEXTURE,           texture,
   PSYS_SRC_MAX_AGE,0,
   PSYS_PART_MAX_AGE,0.3,
   PSYS_SRC_BURST_RATE,0.3,
   PSYS_SRC_BURST_PART_COUNT,80,
   PSYS_SRC_ACCEL,<0.000000,0.000000,0.000000>,
   PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
   PSYS_SRC_BURST_SPEED_MIN,0.4,
   PSYS_SRC_BURST_SPEED_MAX,0.8,
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}
