package br.com.map.vfapp
import java.io.Serializable
import com.google.gson.Gson

class Scan(val data: String, val symbology: String, val dateTime: String) : Serializable {

    fun toJson(): String {
        return Gson().toJson(this)
    }
}
