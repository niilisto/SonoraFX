//----------------------------------------------------------------------------------
//
// CKEYCONVERT : conversion des keycodes en keycodes java
//
//----------------------------------------------------------------------------------

package Application
{
	import flash.ui.Keyboard;
	
	public class CKeyConvert
	{
	    public static var keys:Array=
	    [
			0x01, 260,		// LButton
			0x02, 02,		// RButton
			0x04, 01,		// MButton
	        0x1B, 27,		// Escape
	        0x0D, 13,		// Return
	        0x10, 16,		// Shift
	        0x11, 17,		// Control
	        0x12, 18,		// Alt
	        0x20, 32,		// Space
	        0x25, 37,	    // 37,		// Left
	        0x26, 38,	    // 38,		// Up
	        0x27, 39,    // 39,		// Right
	        0x28, 40,	    // 40,		// Down
	        144, 144,		// Numlock
	        0x6F, 111,		// Divide
	        0x6A, 106,		// Multiply
	        0x6D, 109,		// Subtract
	        0x6B, 107,		// Add
	        0x6E, 110,		// Decimal
	        226, 226,		// Inferieur
	        221, 221,	    // Accent circonflexe
	        186, 186,		// Dollar
	        219, 219,		// Parenthese fermee
	        187, 187,		// Egal
	        0x08, 8,		// Backspace
			0x2D, 45,		// INSERT
	        0x24, 36,		// HOME
	        0x2E, 46,		// Delete
	        0x23, 35,		// End
	        0x21, 33,		// Prev page
	        0x22, 34,		// Next page
	        0x09, 9,		// Tab
			188, 188,		// Virgule
			190, 190,	// Point virgule
			191, 191,		// Deux points
			223, 223,	// !
	        0x70, 112,
	        0x71, 113,
	        0x72, 114,
	        0x73, 115,
	        0x74, 116,
	        0x75, 117,
	        0x76, 118,
	        0x77, 119,
	        0x78, 120,
	        0x79, 121,
	        0x7A, 122,
	        0x7B, 123,
	        0x7C, 124,
	        0x7D, 125,
	        0x7E, 126,
	        0x30, 48,
	        0x31, 49,
	        0x32, 50,
	        0x33, 51,
	        0x34, 52,
	        0x35, 53,
	        0x36, 54,
	        0x37, 55,
	        0x38, 56,
	        0x39, 57,
	        0x41, 65,		// A
	        0x42, 66,		// b
	        0x43, 67,		// c
	        0x44, 68,		// d
	        0x45, 69,		// e
	        0x46, 70,		// f
	        0x47, 71,		// g
	        0x48, 72,		// h
	        0x49, 73,		// i
	        0x4A, 74,		// j
	        0x4B, 75,		// k	
	        0x4C, 76,		// l
	        0x4D, 77,		// m
	        0x4E, 78,		// n
	        0x4F, 79,		// o
	        0x50, 80,		// p
	        0x51, 81,		// q
	        0x52, 82,		// r
	        0x53, 83,		// s
	        0x54, 84,		// t
	        0x55, 85,		// u
	        0x56, 86,		// v
	        0x57, 87,		// w
	        0x58, 88,		// x
	        0x59, 89,		// y
	        0x5A, 90,		// Z
	        0x60, 96,		// Numpad0
	        0x61, 97, 
	        0x62, 98, 
	        0x63, 99, 
	        0x64, 100, 
	        0x65, 101, 
	        0x66, 102, 
	        0x67, 103, 
	        0x68, 104, 
	        0x69, 105,         
	        -1
	    ];
	    public static var NB_SPECIAL_KEYS:int=29;

	    public static var keyNames:Array=
	    [
			"LButton",
			"MButton",
			"RButton",
	        "Escape",
	        "Return", 
	        "Shift",
	        "Control",
	        "Alt",
	        "Space",
	        "Left",
	        "Up",
	        "Right",
	        "Down",
	        "Numlock",
	        "Divide",
	        "Multiply",
	        "Subtract",
	        "Add",
	        "Decimal",
	        "Key1",
	        "Key2",
	        "Key3",
	        "Close bracket",
	        "Equal",
	        "Backspace",
			"Insert",
	        "Home",
	        "Delete",
	        "End",
	        "Previous page",
	        "Next page",
	        "Tab",
			"Comma",
			"Semi colon",
			"Colon",
			"Exclamation",
			"Unknown",
	    ];
	    
		public function CKeyConvert()
		{
		}
	    public static function getFlashKey(pcKey:int):int
	    {
	        var n:int;
	        for (n=0; keys[n]!=-1; n+=2)
	        {
	            if (keys[n]==pcKey)
	            {
	                return keys[n+1];
	            }
	        }
	        return pcKey;
	    }
	    // Get key text
	    public static function getKeyText(vkCode:int):String
	    {
	    	var c:int;
			var s:String="";
			
			// Rechercher la touche parmi les touches speciales
			// ------------------------------------------------
			if ( vkCode >= 96 && vkCode <= 105 )			// NUMPAD_0
			{
				c= vkCode-96;
				s="Numpad"+c.toString();
			}
			else if ( vkCode >= 112 && vkCode <= 126 )		// F1
			{
				c=vkCode-112;
				s="F"+c.toString();
			}
			else if ( vkCode >= 48 && vkCode <= 57 )		// NUMBER_0
			{
				c=vkCode-48;
				s=c.toString();
			}
			else if ( vkCode >= 65 && vkCode <= 90 )		// A
			{
			    s=String.fromCharCode(vkCode);
			}
			else
			{
			    var n:int;
			    for (n=0; n<NB_SPECIAL_KEYS; n++)
			    {
					if (keys[n*2+1]==vkCode)
					{
					    s=keyNames[n];
					    break;
					}
			    }
			}
		    return s;
	    }

	}
}