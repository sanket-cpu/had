package com.example.sqlite; 
 
import androidx.appcompat.app.AppCompatActivity; 
 
import android.opengl.GLDebugHelper; 
import android.os.Bundle; 
import android.view.View; 
import android.widget.Button; 
import android.widget.EditText; 
import android.widget.TextView; 
import android.widget.Toast; 
 
public class MainActivity extends AppCompatActivity { 
EditText user, passw; 
Button register, update, delete , display ; 
TextView res; 
dhhelper dbHelper; 
 
    private static final String dbName = "studentdb"; 
    private static final String tbName = "student"; 
    private static final int dbVersion = 1; 
 
    @Override 
    protected void onCreate(Bundle savedInstanceState) { 
        super.onCreate(savedInstanceState); 
        setContentView(R.layout.activity_main); 
        user = findViewById(R.id.editTextTextPersonName); 
        passw = findViewById(R.id.password); 
        register = findViewById(R.id.register); 
        update= findViewById(R.id.update); 
        delete = findViewById(R.id.delete); 
        display = findViewById(R.id.display); 
       res = findViewById(R.id.res); 
        dbHelper = new dhhelper(MainActivity.this,dbName, null,dbVersion); 
 
        register.setOnClickListener(new View.OnClickListener() { 
            @Override 
            public void onClick(View view) { 
                long val = dbHelper.adduser(user.getText().toString(), passw.getText().toString()); 
                if (val == -1) { 
                    Toast.makeText(MainActivity.this, "Error in adding user", Toast.LENGTH_SHORT).show(); 
                } else 
                    Toast.makeText(MainActivity.this, "USER REGISTERED", Toast.LENGTH_SHORT).show(); 
            } 
        }); 
 
        update.setOnClickListener(new View.OnClickListener() { 
            @Override 
            public void onClick(View view) { 
                dbHelper.update(user.getText().toString(), passw.getText().toString()); 
            } 
        }); 
 
delete.setOnClickListener(new View.OnClickListener() { 
    @Override 
    public void onClick(View view) { 
        dbHelper.delete(user.getText().toString()); 
    } 
}); 
 
display.setOnClickListener(new View.OnClickListener() { 
    @Override 
    public void onClick(View view) { 
        String out = dbHelper.display(MainActivity.this); res.setText(out); 
    } 
}); 
 
    } 
} 
 
 
 
 
 
package com.example.sqlite; 
 
import android.content.ContentValues; 
import android.content.Context; 
import android.database.Cursor; 
import android.database.sqlite.SQLiteDatabase; 
import android.database.sqlite.SQLiteOpenHelper; 
 
import androidx.annotation.Nullable; 
 
public class dhhelper extends SQLiteOpenHelper { 
    private static final String dbName ="studentdb"; 
    private static final String tbName = "student"; 
    private static final int dbversion = 1; 
    public dhhelper(@Nullable Context context , @Nullable String name, @Nullable SQLiteDatabase.CursorFactory 
factory,int version) 
    { 
        super(context,dbName,factory, dbversion); 
 
    } 
    @Override 
    public void onCreate(SQLiteDatabase sqLiteDatabase) { 
          sqLiteDatabase.execSQL("CREATE TABLE " + tbName + "(uname VARCHAR(10), passw 
VARCHAR(10))"+";"); 
    } 
 
    @Override 
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int oldversion, int newversion) { 
        sqLiteDatabase.execSQL("drop table if exists " + tbName); 
        onCreate(sqLiteDatabase); 
 
    } 
    public long adduser(String name,String pass) 
    { 
        SQLiteDatabase sqLiteDatabase = this.getWritableDatabase(); 
        ContentValues cv = new ContentValues(); 
        cv.put("uname",name); 
        cv.put("passw",pass); 
        long result = sqLiteDatabase.insert(tbName, null,cv); 
        sqLiteDatabase.close(); 
        return result ; 
    } 
    public void update(String name, String pass){ 
        SQLiteDatabase sqLiteDatabase = this.getWritableDatabase(); 
        sqLiteDatabase.execSQL("UPDATE "+tbName+" SET passw='"+pass+ "'" +" WHERE uname='"+name+"';"); 
        sqLiteDatabase.close(); 
    } 
    public void delete(String name) { 
        SQLiteDatabase sqLiteDatabase = this.getWritableDatabase(); 
        sqLiteDatabase.execSQL("DELETE FROM " + tbName + " WHERE uname='" + name + "';"); 
        sqLiteDatabase.close(); 
    } 
    public String display(Context ctx) { 
        SQLiteDatabase sqLiteDatabase = this.getReadableDatabase(); //8(a) 
        Cursor cursor = sqLiteDatabase.rawQuery("SELECT * FROM " + tbName, null); 
        String finalres = " "; 
        while (cursor.moveToNext()) { //8(c) 
            finalres += cursor.getString(0) + ":" + cursor.getString(1); // 8(d) 
        } 
        return finalres; 
    } 
 
 
} 
 
 
 
 
 
<?xml version="1.0" encoding="utf-8"?> 
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android" 
    xmlns:app="http://schemas.android.com/apk/res-auto" 
    xmlns:tools="http://schemas.android.com/tools" 
    android:layout_width="match_parent" 
    android:layout_height="match_parent" 
    android:orientation="vertical" 
    tools:context=".MainActivity" 
    > 
 
    <TextView 
        android:id="@+id/textView" 
        android:layout_width="match_parent" 
        android:layout_height="wrap_content" 
 
        android:text="Sqlite database" 
        android:textSize="30dp" 
        android:layout_marginTop="50dp" 
        android:gravity="center"/> 
 
    <EditText 
        android:id="@+id/editTextTextPersonName" 
        android:layout_width="match_parent" 
        android:layout_height="wrap_content" 
        android:ems="10" 
        android:inputType="textPersonName" 
        android:layout_marginTop="20dp" 
        android:gravity="left" 
        android:hint="name"/> 
    <EditText 
        android:layout_width="match_parent" 
        android:layout_height="wrap_content" 
        android:id="@+id/password" 
        android:hint="password" 
        android:layout_marginTop="25dp" 
        android:inputType="numberPassword" 
        /> 
    <LinearLayout 
        android:layout_width="match_parent" 
        android:layout_height="wrap_content" 
        android:orientation="horizontal" 
        android:layout_marginTop="100dp"> 
    <Button 
        android:layout_width="wrap_content" 
        android:layout_height="wrap_content" 
        android:id="@+id/register" 
        android:layout_marginLeft = "20dp" 
 
        android:layout_weight="0.25" 
        android:text="Register" /> 
        <Button 
            android:layout_width="wrap_content" 
            android:layout_height="wrap_content" 
            android:id="@+id/update" 
            android:layout_weight="0.25" 
            android:layout_marginLeft="10dp" 
            android:layout_marginRight="10dp" 
            android:text="Update" /> 
 
 
 
        </LinearLayout> 
 
 
    <LinearLayout 
        android:layout_width="match_parent" 
        android:layout_height="wrap_content" 
        android:orientation="horizontal" 
        android:layout_marginTop="25dp" 
        > 
        <Button 
            android:layout_width="wrap_content" 
            android:layout_height="wrap_content" 
            android:id="@+id/delete" 
            android:layout_marginLeft = "20dp" 
            android:layout_weight="0.25" 
            android:text="delete" /> 
        <Button 
            android:layout_width="wrap_content" 
            android:layout_height="wrap_content" 
            android:id="@+id/display" 
            android:layout_weight="0.25" 
            android:layout_marginLeft="10dp" 
            android:layout_marginRight="10dp" 
            android:text="display" /> 
 
 
 
    </LinearLayout> 
 
    <TextView 
        android:layout_width="match_parent" 
        android:layout_height="wrap_content" 
        android:id="@+id/res" 
        android:layout_marginTop="50dp" 
        /> 
 
</LinearLayout> 
