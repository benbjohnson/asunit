package asunit.framework {

    import asunit.util.Iterator;

	import flash.utils.getDefinitionByName;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionVariable;
    import p2.reflect.ReflectionMetaData;

	public class SuiteIterator implements Iterator {
		
        protected var index:int;
        protected var list:Array;
				
		public function SuiteIterator(Suite:Class, result:IResult=null) {
			list = getTestClasses(Suite, result);
		}
		
        private function getTestClasses(Suite:Class, result:IResult=null):Array {
            // Careful - this behavior caused some headaches
            // when I was getting a null result (it was from the recursion below)
            if(result == null) result = new Result();

            var reflection:Reflection = Reflection.create(Suite);

            if(!isSuite(reflection) && isTest(reflection)) {
                return [Suite];
            }

            var variable:ReflectionVariable;
            var TestConstructor:Class;
            var response:Array = [];
            for each(variable in reflection.variables) {
                TestConstructor = Class(getDefinitionByName(variable.type));
                if(isSuite(Reflection.create(TestConstructor))) {
                    response = response.concat( getTestClasses(TestConstructor, result) );
                }
                else if(result.shouldRunTest(TestConstructor)) {
                    response.push(TestConstructor);
                }
            }
            response.sort();
            return response;
        }

        public function get length():uint {
            return list.length;
        }

		private function isSuite(reflection:Reflection):Boolean {
            return RunnerFactory.isSuite(reflection);
		}

        private function isTest(reflection:Reflection):Boolean {
            return RunnerFactory.isTest(reflection);
        }
        
        public function hasNext():Boolean {
            return list[index] != null;
        }

        // Returns a Class reference:
        public function next():* {
            return list[index++];
        }

        public function reset():void {
            index = 0;
        }
	}
}

