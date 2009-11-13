var Lyrics = {};
Lyrics.Fetcher = Class.create({

    initialize: function(lyricsDiv) {
        this.lyricsDiv = $(lyricsDiv);
    },
    
    fetch: function(title, artist) {
        
    },
    
    fetchSucceeded: function(transport) {
        
    },
    
    fetchFailed: function(transport) {
        
    },
    
    fetchComplete: function(transport) {
        
    }

});

Lyrics.Fetcher.LyricWiki = Class.create({

    initialize: function(lyricsDiv) {
        this.lyricsDiv = $(lyricsDiv);
    },
    
    fetch: function(title, artist) {
        t = this;
        new Ajax.Updater(this.collectionDivName(collection), this.collectionURL(collection), {
            method: 'get', 
            evalScripts:false, 
            onSuccess: function(transport){t.fetchSucceeded(transport);},
            onFailure: function(transport){t.fetchFailed(transport);},
            onComplete: function(transport){t.fetchComplete(transport);}
        });
    },
    
    fetchSucceeded: function(transport) {
        
    },
    
    fetchFailed: function(transport) {
        
    },
    
    fetchComplete: function(transport) {
        
    }
    
});