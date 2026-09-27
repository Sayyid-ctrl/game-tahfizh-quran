$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8085/')
$listener.Start()
Write-Host "Server running at http://localhost:8085/"

$root = "c:\Users\LENOVO\Desktop\game edukasi tahfizh"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    $reqPath = $request.Url.LocalPath
    if ($reqPath -eq "/") { $reqPath = "/index.html" }
    
    $filePath = Join-Path $root ($reqPath -replace "^/", "")
    
    if (Test-Path $filePath -PathType Leaf) {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $bytes.Length
        
        if ($filePath.EndsWith(".html")) { $response.ContentType = "text/html; charset=utf-8" }
        elseif ($filePath.EndsWith(".json")) { $response.ContentType = "application/json" }
        elseif ($filePath.EndsWith(".js")) { $response.ContentType = "application/javascript" }
        elseif ($filePath.EndsWith(".css")) { $response.ContentType = "text/css" }
        
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $response.StatusCode = 404
        $notFoundMsg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
        $response.OutputStream.Write($notFoundMsg, 0, $notFoundMsg.Length)
    }
    $response.Close()
}
git init
git add .
git commit -m "Deploy Game Tahfizh PWA"
git branch -M main
git remote add origin https://github.com/<Sayyid-ctrl>/game-tahfizh-quran.git
git push -u origin main

