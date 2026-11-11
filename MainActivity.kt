package com.remotion.rehab
import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Bundle
import android.webkit.*
import androidx.webkit.WebViewAssetLoader

class MainActivity : Activity() {
    private lateinit var wv: WebView
    private var pending: PermissionRequest? = null
    override fun onCreate(b: Bundle?) {
        super.onCreate(b)
        window.addFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        val loader = WebViewAssetLoader.Builder()
            .addPathHandler("/assets/", WebViewAssetLoader.AssetsPathHandler(this)).build()
        wv = WebView(this); setContentView(wv)
        wv.settings.javaScriptEnabled = true
        wv.settings.domStorageEnabled = true
        wv.settings.mediaPlaybackRequiresUserGesture = false
        wv.webViewClient = object : WebViewClient() {
            override fun shouldInterceptRequest(v: WebView, r: WebResourceRequest) =
                loader.shouldInterceptRequest(r.url)
        }
        wv.webChromeClient = object : WebChromeClient() {
            override fun onPermissionRequest(r: PermissionRequest) {
                runOnUiThread {
                    if (checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) r.grant(r.resources)
                    else { pending = r; requestPermissions(arrayOf(Manifest.permission.CAMERA), 1) }
                }
            }
        }
        wv.loadUrl("https://appassets.androidplatform.net/assets/index.html")
    }
    override fun onRequestPermissionsResult(c: Int, p: Array<out String>, g: IntArray) {
        val r = pending ?: return; pending = null
        if (g.isNotEmpty() && g[0] == PackageManager.PERMISSION_GRANTED) r.grant(r.resources) else r.deny()
    }
    @Deprecated("Deprecated in Java")
    override fun onBackPressed() { if (wv.canGoBack()) wv.goBack() else super.onBackPressed() }
}
