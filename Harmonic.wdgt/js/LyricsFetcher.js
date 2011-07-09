Lyrics = {};
LyricsFetcherCallIndex=0;
LyricsFetcherSuccessIndex=0;

Lyrics.Fetcher = Class.create({

    initialize: function(lyricsDiv) {
        this.lyricsDiv = $(lyricsDiv);
    },
    
    fetch: function(artist,title) {
        
    },
    
    fetchSucceeded: function(transport) {
        
    },
    
    fetchFailed: function(transport) {
        
    },
    
    fetchComplete: function(transport) {
        
    }

});

//http://www.chartlyrics.com/api.aspx
Lyrics.Fetcher.ChartLyrics = Class.create({

    initialize: function(lyricsDiv) {
        this.lyricsDiv = $(lyricsDiv);
    },
    
    fetch: function(artist,title) {
        if(LyricsFetcherSuccessIndex>0) return;
        LyricsFetcherCallIndex++;
        
        var url='http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist='+artist+'&song='+title;
        
        alert(url);
        new Ajax.Request(url, {
            method: 'get', 
            onFailure: this.fetchFailed.bind(this),
            onComplete: this.fetchComplete.bind(this) 
        });
    },
    
    
    fetchFailed: function(transport) {
        alert('error while fetching from ChartLyrics');
        
        LyricsFetcherCallIndex--;
        if(LyricsFetcherCallIndex==0&&LyricsFetcherSuccessIndex==0){
            filedLyricsFetching();
        }
        
    },
    
    fetchComplete: function(transport) {
        
        if(LyricsFetcherSuccessIndex>0) return;
        
        if(transport.responseXML!=null && transport.responseXML.getElementsByTagName('Lyric')[0]!=undefined){
            var lyrics=transport.responseXML.getElementsByTagName('Lyric')[0].childNodes[0].nodeValue;
            if(lyrics!=''&&lyrics!=undefined){
            
                LyricsFetcherSuccessIndex++;
                LyricsFetcherCallIndex--;
                
                alert(lyrics);
                setLyricsText(lyrics);
                HarmonicPlugin.setLyrics(lyrics);
            }else{
                this.fetchFailed(transport);
            }
        }else{
            this.fetchFailed(transport);
        }    
    }
    
});
//http://www.chartlyrics.com/api.aspx
Lyrics.Fetcher.lyrdb = Class.create({

    initialize: function(lyricsDiv) {
        this.lyricsDiv = $(lyricsDiv);
    },
    
    fetch: function(artist,title) {
        if(LyricsFetcherSuccessIndex>0) return;
        LyricsFetcherCallIndex++;
        
        var filter=/[^ \w]/ig;
        
        var url='http://webservices.lyrdb.com/lookup.php?q='+artist.replace(filter,'')+'|'+title.replace(filter,'')+'&for=match&agent=Harmonic%20MacOS%20Dashboard';
        
        alert(url);
        new Ajax.Request(url, {
            method: 'get', 
            onFailure: this.fetchFailed.bind(this),
            onComplete: this.idFetchComplete.bind(this) 
        });
    },
    
    idFetchComplete:function(transport) {
        if(LyricsFetcherSuccessIndex>0) return;
        
        idMatch=transport.responseText.match(/(\w+)(?=\\[\w\s]+\\[\w\s]+)/ig)
        if(idMatch){
            var url='http://webservices.lyrdb.com/getlyr.php?q='+idMatch[0];
        
            alert(url);
            new Ajax.Request(url, {
            method: 'get', 
                onFailure: this.fetchFailed.bind(this),
                onComplete: this.fetchComplete.bind(this) 
            });
        }else{
            this.fetchFailed(transport);
        }    
    },
    
    fetchFailed: function(transport) {
        alert('error while fetching from lyrdb');
        
        LyricsFetcherCallIndex--;
        if(LyricsFetcherCallIndex==0&&LyricsFetcherSuccessIndex==0){
            filedLyricsFetching();
        }
        
    },
    
    fetchComplete: function(transport) {
        
        
        if(LyricsFetcherSuccessIndex>0) return;
        
        if(transport.responseText!=null && transport.responseText!='' && !transport.responseText.match(/^error:\w+/i)){
            LyricsFetcherSuccessIndex++;
            LyricsFetcherCallIndex--;
                
                
            lyrics=transport.responseText;
            alert(lyrics);
            setLyricsText(lyrics);
            HarmonicPlugin.setLyrics(lyrics);
        }else{
            this.fetchFailed(transport);
        }    
    }
    
});
