package Game {
	import flash.display.*;
	import flash.geom.*;
	
	public final class Treasure extends MovieClip {
		public var isGem:Boolean;
		public var theMask:MovieClip;
		
		public function Initialize (IsGem:Boolean, coords:Point, TheMask:MovieClip) {
			isGem = IsGem;
			theMask = TheMask;
			
			var treasure:MovieClip;
			
			if (isGem) {
				treasure = new mcGem ();
			} else {
				treasure = new mcCoin ();
			}
			
			treasure.gotoAndStop (Math.floor (Math.random () * treasure.totalFrames) + 1);
			treasure.rotation = Math.random () * 360;
			addChild (treasure);

			x = coords.x;
			y = coords.y;
		}
	}
}