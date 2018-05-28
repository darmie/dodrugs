import utest.Assert;
import dodrugs.*;
import haxe.ds.ArraySort;
import haxe.ds.StringMap;

@:keep
class TestMacroUtils {
	public function new() {}

	function testInjectionIds() {
		// Test `var id:Type = val` and plain `TypePath` syntax.
		Assert.equals("String", Injector.getInjectionString(String));
		Assert.equals("StdTypes.Int", Injector.getInjectionString(Int));
		Assert.equals("StringBuf", Injector.getInjectionString(StringBuf));
		Assert.equals("String", Injector.getInjectionString(var _:String));
		Assert.equals("StdTypes.Int", Injector.getInjectionString(var _:Int));
		Assert.equals("StringBuf", Injector.getInjectionString(var _:StringBuf));
		// Test injection IDs for types in packages.
		Assert.equals("haxe.ds.ArraySort", Injector.getInjectionString(ArraySort));
		Assert.equals("haxe.crypto.Sha1", Injector.getInjectionString(haxe.crypto.Sha1));
		Assert.equals("haxe.ds.ArraySort", Injector.getInjectionString(var _:ArraySort));
		Assert.equals("haxe.crypto.Sha1", Injector.getInjectionString(var _:haxe.crypto.Sha1));
		// Test injection IDs that have type parameters
		Assert.equals("Array<String>", Injector.getInjectionString(var _:Array<String>));
		Assert.equals("haxe.ds.StringMap<StdTypes.Int>", Injector.getInjectionString(var _:StringMap<Int>));
		// Test injection IDs that have a name
		Assert.equals("haxe.ds.ArraySort quicksort", Injector.getInjectionString(var quicksort:ArraySort));
		Assert.equals("haxe.crypto.Sha1 myhash", Injector.getInjectionString(var myhash:haxe.crypto.Sha1));
		Assert.equals("StdTypes.Int sessionExpiry", Injector.getInjectionString(var sessionExpiry:Int));
		Assert.equals("Array<StdTypes.Int> magicNumbers", Injector.getInjectionString(var magicNumbers:Array<Int>));
		// Check the injector itself maps correctly.
		Assert.equals('dodrugs.Injector<"test">', Injector.getInjectionString(var _:Injector<"test">));
		Assert.equals('dodrugs.Injector<"test2">', Injector.getInjectionString(var _:dodrugs.Injector<"test2">));

		var sessionExpiry = 3600;
		Assert.equals('StdTypes.Int sessionExpiry', Injector.getInjectionString(sessionExpiry));
		Assert.equals('StdTypes.Int', Injector.getInjectionString(2000));

		Assert.equals('TestMacroUtils', Injector.getInjectionString(new TestMacroUtils()));
	}

	function testUniqueNames() {
		var i1:Injector<"test_1"> = null;
		var i2:Injector<"test_1"> = null;
		var i3:Injector<"test_2"> = null;
		var i4:UntypedInjector = null;
		var i5 = Injector.create( "test_1", [] );

		Assert.equals( "dodrugs.Injector", Type.getClassName(Type.getClass(i5)) );
		Assert.equals( "test_1", i5.name );

		// Compile Time Error:
		// var i6 = Injector.create( "test_1", [] );
	}

	function testGetInjectionMapping() {
		// Test value mapping
		var result = Injector.getInjectionMapping(var _:Int = 3600);
		Assert.same("StdTypes.Int", result.id);
		Assert.same(3600, result.mappingFn(null,""));

		// Test function mapping
		var fn = function(inj,id) return null;
		var result = Injector.getInjectionMapping(var test:Array<Int> = @:toFunction fn);
		Assert.equals("Array<StdTypes.Int> test", result.id);
		Assert.equals(fn, result.mappingFn);

		// Test function singleton mapping
		var fn = function(inj,id) return [];
		var mapping = Injector.getInjectionMapping(var test:Array<Int> = @:toSingletonFunction fn);
		var inj = @:privateAccess new dodrugs.UntypedInjector(null, {
			"some_id": mapping.mappingFn
		});
		Assert.equals("Array<StdTypes.Int> test", mapping.id);
		var firstGet = inj.getFromId("some_id");
		var secondGet = inj.getFromId("some_id");
		Assert.equals(firstGet, secondGet);

		// Just test these don't throw errors.
		// We'll check the class instantiation functions in `ClassInstantiation.hx`
		Injector.getInjectionMapping(var _:Test = @:toClass Test);
		Injector.getInjectionMapping(var _:InjectionTestClasses.ApiTest = @:toSingletonClass InjectionTestClasses.MyApiTest);
	}
}

