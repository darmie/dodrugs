import utest.Assert;
import dodrugs.*;
import haxe.ds.ArraySort;
import haxe.ds.StringMap;

@:keep
class TestMacroUtils {
	public function new() {}

	function testInjectionIDs() {
		// Test Injection IDs for standard types.
		Assert.equals( "String.String", Injector.getInjectionString(String) );
		Assert.equals( "StdTypes.Int", Injector.getInjectionString(Int) );
		Assert.equals( "StringBuf.StringBuf", Injector.getInjectionString(StringBuf) );
		Assert.equals( "StdTypes.Int", Injector.getInjectionString("Int") );
		Assert.equals( "StringBuf.StringBuf", Injector.getInjectionString("StringBuf") );
		// Test injection IDs for types in packages.
		Assert.equals( "haxe.ds.ArraySort.ArraySort", Injector.getInjectionString(ArraySort) );
		Assert.equals( "haxe.crypto.Sha1.Sha1", Injector.getInjectionString(haxe.crypto.Sha1) );
		// Test injection IDs that have type parameters
		Assert.equals( "Array.Array<String.String>", Injector.getInjectionString("Array<String>") );
		Assert.equals( "haxe.ds.StringMap.StringMap<StdTypes.Int>", Injector.getInjectionString("StringMap<Int>") );
		// Test injection IDs that have a name
		Assert.equals( "haxe.ds.ArraySort.ArraySort quicksort", Injector.getInjectionString(ArraySort.withId("quicksort")) );
		Assert.equals( "haxe.crypto.Sha1.Sha1 myhash", Injector.getInjectionString(haxe.crypto.Sha1.withId("myhash")) );
		Assert.equals( "StdTypes.Int sessionExpiry", Injector.getInjectionString(Int.withId("sessionExpiry")) );
		Assert.equals( "Array.Array<StdTypes.Int> magicNumbers", Injector.getInjectionString("Array<Int>".withId("magicNumbers")) );
		// Test the `ECheckType` syntax:
		Assert.equals( "StringBuf.StringBuf", Injector.getInjectionString((_:StringBuf)) );
		Assert.equals( "Array.Array<String.String>", Injector.getInjectionString((_:Array<String>)) );
		Assert.equals( "StdTypes.Int sessionExpiry", Injector.getInjectionString((sessionExpiry:Int)) );
		Assert.equals( "Array.Array<StdTypes.Int> magicNumbers", Injector.getInjectionString((magicNumbers:Array<Int>)) );
		// Check the injector itself maps correctly.
		Assert.equals( 'dodrugs.Injector<"test">', Injector.getInjectionString((_:Injector<"test">)) );
		Assert.equals( 'dodrugs.Injector<"test2">', Injector.getInjectionString((_:dodrugs.Injector<"test2">)) );
		Assert.equals( 'dodrugs.Injector<"test3">', Injector.getInjectionString('Injector<"test3">') );
		Assert.equals( 'dodrugs.Injector<"test4">', Injector.getInjectionString('dodrugs.Injector<"test4">') );
	}

	function testUniqueNames() {
		var i1:Injector<"test_1"> = null;
		var i2:Injector<"test_1"> = null;
		var i3:Injector<"test_2"> = null;
		var i4:DynamicInjector = null;
		var i5 = Injector.create( "test_1", [] );

		Assert.equals( "dodrugs.Injector", Type.getClassName(Type.getClass(i5)) );
		Assert.equals( "test_1", i5.name );

		// Compile Time Error:
		// var i6 = Injector.create( "test_1", [] );
	}

	function testGetInjectionMapping() {
		var result = Injector.getInjectionMapping( Int.toValue(3600) );
		Assert.same( "StdTypes.Int", result.id );
		Assert.same( 3600, result.mappingFn(null,"") );

		var fn = function(inj,id) return null;
		var result = Injector.getInjectionMapping( "Array<Int>".withId("test").toFunction(fn) );
		Assert.equals( "Array.Array<StdTypes.Int> test", result.id );
		Assert.equals( fn, result.mappingFn );

		// Just test these don't throw errors.
		// We'll check the class instantiation functions in `ClassInstantiation.hx`
		var result = Injector.getInjectionMapping( Test.toClass(Test) );
		var result = Injector.getInjectionMapping( haxe.remoting.Connection.toSingleton(haxe.remoting.HttpConnection) );
	}
}
