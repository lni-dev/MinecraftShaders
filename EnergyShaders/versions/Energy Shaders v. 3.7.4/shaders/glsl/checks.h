/**
 * Copyright 2022 LinusDev
 * @author LinusDev (einsuperlinus@gmail.com)
 */

 /**
  *
  * FOG_CONTROL
  *
  * Note: + or - after a number means slightly higher or lower
  *       +- means around (unknown if slightly higher or lower)
  *
  * FOG_CONTROL.x changes:
  * normal=0.6+
  * inInventory=0.9+ drops down upto 0.5 (no rain, depends on time spent in inventory) when inventory is left. Then slowly returns back to normal (or rain)
  * rain=0.21+-
  * thunder=0.2
  *
  * FOG_CONTROL.y changes:
  * normal=1.0
  * inInventory=1.0 drops down upto 0.5 (no rain, depends on time spent in inventory) when inventory is left. Then slowly returns back to normal (or rain)
  * rain=0.7
  * thunder=0.7
  */

/**
 * returns 0.0 for no rain and 1.0 for rain. based on FOG_CONTROL.xy.
 * 1.0 may not be reached (but should).
 * If inventory is opened in rain, it may be buggy.
 */
  float getRain(float x, float y) {
    return min(1.0, max(0.0, ((y - x*0.7) - x)* 7.0));
  }

  /**
   * returns true if player is in inventory. based on FOG_CONTROL.xy.
   */
  bool inInventory(float x, float y) {
    return x > 0.8999;
  }
