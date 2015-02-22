package Game {
	import flash.geom.*;
	import Screener.*;
	
	public final class GameData {
		public static var soundOn:Boolean = true;
		public static var musicOn:Boolean = true;
		
		public static const worldSpeed:int = 7;
		
		public static const numSpikes:int = 18;
		public static const spikeWidth:int = 50;
		public static const minSpikeHeight:int = 25;
		public static const maxSpikeHeightDifference:int = 40;
		public static const hardMaxSpikeHeightDifference:int = 60;
		public static const minPathHeight:int = 200;
		public static const hardMinPathHeight:int = 100;
		public static const maxPathHeight:int = 250;
		public static const hardMaxPathHeight:int = 200;
		public static const framesToHard:int = 7200;
		
		public static const maxLightSize:int = 900;
		public static const minLightSize:int = 250;
		public static const framesToMinLight:int = 2700;
		
		public static const avatarSize:Point = new Point (50, 13.7);
		
		public static const maxYSpeed:int = 3;
		public static const gravity:Number = 0.5;
		public static const maxRotation:int = 15;
		public static const rotateSpeed:int = 2;
		
		public static const maxBubbleSpeed:int = 5;
		
		public static const cloneDebut:int = 4350;
		public static const cloneCountdown:int = 300;
		public static const cloneSpeed:int = 25;
		public static const maxClones:int = 3;
		
		public static const treasureDebut:int = 450;
		public static const gemCountdown:int = 300;
		public static const gemMult:Number = 0.2;
		public static const coinCountdown:int = 150;
		public static const coinScore:int = 100;
		public static const treasureLightSize:int = 150;
		
		public static const soundDebut:int = 2300;
		public static const soundCountdown:int = 210;
		
		public static const countdownDeviation:Number = 0.2;
		
		public static const blurOutFrames:int = 30;
		public static const maxBlur:int = 128;
		
		public static const thoughtFrames:int = 150;
		public static const thoughts:Object = {
		start:{thought:"I heard there's glowing treasure in this cave.", auto:true, debut:0, voice:sndStart},
		wall:{thought:"The walls look really sharp, I better avoid them.", auto:true, debut:180, voice:sndWall},
		dark:{thought:"Pitch black in here.", auto:true, debut:450, voice:sndDark},
		light:{thought:"I think there's something up ahead!", auto:true, debut:600, voice:sndLight},
		treasure:{thought:"The stories are true! Glowing treasure!", auto:false, voice:sndTreasure},
		battery:{thought:"Uh oh, the batteries in my goggles are running low.", auto:true, debut:1350, voice:sndBattery},
		sound:{thought:"What was that sound?", auto:true, debut:2600, voice:sndSound},
		erratic:{thought:"I think the cave is getting smaller.", auto:true, debut:3600, voice:sndErratic},
		sound2:{thought:"I keep hearing strange sounds.", auto:true, debut:3900, voice:sndSound2},
		alone:{thought:"I can't help but feel I'm not alone.", auto:true, debut:4500, voice:sndAlone},
		clone:{thought:"What was that? I swear something just swam past me.", auto:true, debut:4650, voice:sndClone}
		};
		
		public static const wallColor:Number = 0x996600;
		
		public static var score:int = 0;
		public static var numGems:int = 0;
		public static var numGemsGot:int = 0;
		public static var numCoins:int = 0;
		public static var numCoinsGot:int = 0;
		
		public static function Reset () {
			score = 0;
			numGems = 0;
			numGemsGot = 0;
			numCoins = 0;
			numCoinsGot = 0;
		}
	}
}