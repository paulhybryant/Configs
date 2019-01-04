var express = require('express');
var app = express();

// 定义本地服务器的端口
var port = 8808;

// 设置dist目录为静态文件目录
app.use(express.static('./dist'));

app.listen(port, function(){
    console.log('本地服务器运行在：localhost:' + port);
});
