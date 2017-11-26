import dodrugs.Injector;
import Example.Person;
import utest.Assert;

@:keep
class TestChildInjector {
	public function new() {}

	function testParentInjector() {
		var ufInjector = getUfrontInjector();
		var myInjector = getMyInjector(ufInjector);

		Assert.equals("Anna", myInjector.get(var name:String));
		Assert.equals(26, myInjector.get(var age:Int));
	}

	function getMyInjector(parent:Injector<"ufront-app-injector">) {
		return Injector.extend("my-app-injector", parent, [
			var name:String = "Anna"
		]);
	}

	function getUfrontInjector() {
		return Injector.create("ufront-app-injector", [
			var age:Int = 26,
		]);
	}

	function testTemporarilyExtend() {
		var ufInjector = getUfrontInjector();
		var myInjector = ufInjector.temporarilyExtend([
			var name: String = "Anna"
		]);

		Assert.equals("Anna", myInjector.get(var name:String));
		Assert.equals(26, myInjector.get(var age:Int));
	}

	function testParentNeedsChildMapping() {
		var parent = Injector.create('parent which needs child', [
			var _:Array<Int> = [1,2,3],
			Person
		]);
		var child1 = Injector.extend("child 1 which supplies parent", parent, [
			var age:Int = 30,
			var name:String = "Jason",
		]);
		var child2 = Injector.extend("child 2 which supplies parent", parent, [
			var age:Int = 27,
			var name:String = "Anna",
		]);
		var person1 = child1.get(Person);
		var person2 = child2.get(Person);
		Assert.equals('Jason', person1.name);
		Assert.equals('Anna', person2.name);
		Assert.equals(30, person1.age);
		Assert.equals(27, person2.age);
	}
}
