package Game {
	import flash.events.Event;
	
	public final class GameEvent extends Event {
		public static const PlayerHitSpikes:String = "a";
		public static const CloneOffScreen:String = "b";
		public static const TreasureOffScreen:String = "c";
		public static const ObjectOffScreen:String = "e";
		public static const PickTreasure:String = "d";
		
		public var data:* = null;
		
		public function GameEvent (type:String, Data:* = null) {
			data = Data;
			super (type);
		}
	}
}