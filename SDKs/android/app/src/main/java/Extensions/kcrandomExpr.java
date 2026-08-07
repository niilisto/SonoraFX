/* Copyright (c) 1996-2013 Clickteam
 *
 * This source code is part of the Android exporter for Clickteam Multimedia Fusion 2.
 * 
 * Permission is hereby granted to any person obtaining a legal copy 
 * of Clickteam Multimedia Fusion 2 to use or modify this source code for 
 * debugging, optimizing, or customizing applications created with 
 * Clickteam Multimedia Fusion 2.  Any other use of this source code is prohibited.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
package Extensions;

/**
 * by Greyhill
 * @author Admin
 */

import Expressions.CValue;

public class kcrandomExpr
{
    static final int EXP_RANDOM			=		0;
    static final int EXP_RANDOM_MIN_MAX		=	1;
    static final int EXP_GET_SEED		=		2;
    static final int EXP_RANDOM_LETTER		=	3;
    static final int EXP_RANDOM_ALPHANUM	=		4;
    static final int EXP_RANDOM_CHAR		=		5;
    static final int EXP_ASCII_TO_CHAR		=	6;
    static final int EXP_CHAR_TO_ASCII		=	7;
    static final int EXP_TO_UPPER		=		8;
    static final int EXP_TO_LOWER		=		9;
    
    CRunkcrandom thisObject;

    public kcrandomExpr(CRunkcrandom object){
        thisObject = object;
    }
    public CValue get(int num)
    {
        switch (num){
            case EXP_RANDOM:
                return new CValue(thisObject.random(thisObject.ho.getExpParam().getInt()));
            case EXP_RANDOM_MIN_MAX:
                return new CValue(thisObject.randommm(thisObject.ho.getExpParam().getInt(), thisObject.ho.getExpParam().getInt()));
            case EXP_GET_SEED:
                return new CValue(thisObject.lastSeed);
            case EXP_RANDOM_LETTER:
                return GetRandomLetter();
            case EXP_RANDOM_ALPHANUM:
                return GetRandomAlphaNum();
            case EXP_RANDOM_CHAR:
                return GetRandomChar();
            case EXP_ASCII_TO_CHAR:
                return GetAsciiToChar(thisObject.ho.getExpParam().getInt());
            case EXP_CHAR_TO_ASCII:
                return GetCharToAscii(thisObject.ho.getExpParam().getString());
            case EXP_TO_UPPER:
                return new CValue(thisObject.ho.getExpParam().getString().toUpperCase());
            case EXP_TO_LOWER:
                return new CValue(thisObject.ho.getExpParam().getString().toLowerCase());
        }
        return new CValue(0);//won't be used
    }

    private CValue GetRandomLetter(){
        byte b = (byte)thisObject.randommm(97, 122);
        String r = new String(new byte[]{b});
        return new CValue(r);
    }
    private CValue GetRandomAlphaNum(){
        byte b = (byte)thisObject.random(36);
        if (b < 10){
            b += 48;
        } else {
            b += 87;
        }
        String r = new String(new byte[]{b});
        return new CValue(r);
    }
    private CValue GetRandomChar(){
        byte b = (byte)thisObject.random(256);
        String r = new String(new byte[]{b});
        return new CValue(r);
    }
    private CValue GetAsciiToChar(int ascii) {
	byte b = (byte)ascii;
        String r = new String(new byte[]{b});
        return new CValue(r);
    }
    private CValue GetCharToAscii(String c) {
        if (c.length() > 0){
            return new CValue(c.getBytes()[0]);
        }
        return new CValue(0);
    }
}

