package asunit.core {

    public class FlashDevelopCore extends TextCore {

        override protected function initializeObservers():void {
            super.initializeObservers();
            addObserver(new FlashDelopPrinter());
        }

		override protected function onRunCompleted(event:Event):void {
            super.onRunCompleted(event);
			fscommand('quit'); // fails silently if not in debug player
			//System.exit(0); // generates SecurityError if not in debug player
		}
    }
}

