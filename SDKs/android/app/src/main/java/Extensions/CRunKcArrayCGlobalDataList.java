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
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * by Greyhill
 * @author Admin
 */
package Extensions;

import java.util.ArrayList;

public class CRunKcArrayCGlobalDataList extends CExtStorage 
{
    //should be equal, comparable
    ArrayList<Object> dataList;
    ArrayList<String> names;    
    
    public CRunKcArrayCGlobalDataList() 
    {
        dataList = new ArrayList<Object> ();
        names = new ArrayList<String>();
    }
    CRunKcArrayData FindObject(String objectName)
    {
        int names_size = names.size();
    	for (int i = 0; i < names_size; i++)
        {
             if (names.get(i).equals(objectName)== true)
            {
                return (CRunKcArrayData) dataList.get(i);
            }
        }
        return null;
    }
    void AddObject(CRunKcArray o)
    {
        dataList.add(o.pArray);
        names.add(o.ho.hoOiList.oilName);
    }
    
}
