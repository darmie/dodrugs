import dodrugs.*;

class Example {
	static function main() {
		var injector = setupInjector();
		var person = buildPerson(injector);
		trace( 'I am ${person.name}, I am ${person.age} years old and I have ${person.favouriteNumbers.length} favourite numbers' );
	}

	public static function setupInjector() {
		var leastFavouriteNumbers = [-1,3,366];
		return Injector.create("exampleInjector", [
			var age:Int = 28,
			var name:String = "Jason",
			[0, 1, 2],
			leastFavouriteNumbers,
			Person
		]);
	}

	public static inline function buildPerson(injector:Injector<"exampleInjector">) {
		return injector.get(Person);
	}
}

class Person {
	public var name:String;
	public var age:Int;
	public var favouriteNumbers:Array<Int>;
	public var leastFavouriteNumbers:Null<Array<Int>>;

	public function new(name:String, age:Int, anArray:Array<Int>, ?leastFavouriteNumbers:Array<Int>) {
		this.name = name;
		this.age = age;
		this.favouriteNumbers = anArray;
		this.leastFavouriteNumbers = leastFavouriteNumbers;
	}
}
