RuPol
=======

    @@@@@@@@@@@''''@','''''     ',,,''',,,   ',,,         ,,,,,     ,',   ,,,          ,,  
    @@@@@@@@@@@@@@@',,  '@'',   ,@@'  , ,,,,,',,,,,,  ,,,           ,,   ,',,       ,,   ,,
    @@@@@@@@@@@@@@@',,    ''',,,,,    ',,,, ,,                      ,',   ,'',     ,,,    ,
    @@@@@@@@@@@@@@'''@@''''''''',,  ,,,,,,,,,,                      ,,     '''',  ,,',,  ,,
    @@@@@@@@@@@'',''@@'''@@@'''',, ',,, ,,,,,,,                 ,,, ,,    ''@''@' ,,,'',,,,
    @@@@@@@@,  '''',    ''@@@'''''''',,'''''',,,,           ,,,,,,,,,,,   ''@@'',,,,'''''''
    @@@@@@',   '''',    ,'@@@'@@'''''''''''',,,,,,,,,        ,,,,,,,,',,       ,,, '',''' '
    @@@@@''',  '''''    ''@@''''''''''''''',,,,,,,,,,,,       ,,,,,,,'',,         ,''',  ' 
    @@@@@@,,,'@''',,   ,''@''@''''''''''',,,,,,,,,,,, ,'       ,,,,,,,,, ,,,',   '''''  '@'
    @@@@@',,'@@'''     ''@@'@''@@''''''',,,,,,,        ,,'   ,,,,,,,,,''  ,,    ,'''@  ',@@
    @@@@@',  '@'',   ,@@@@@''@@@@'',,''',,,,,,,        ,, ,'     ,,,,''', ,    '''''  '',@@
    @@@@@@'  '@',   ''''' ,'@@@@'''',,  ,',,,      ,   ,,,,,'@     , ''''      ,''' ,'',,,'
    @@@@@@@@@@@', ,'''  ,,'@@@@@@@''''',, ''       ,,,,,,,,,,'@'      ''     ''','',       
    @@@@@@@@@@@'  ,,'  ,''@@@'''@@@@@@@'@''',,,   ,,,,,,,,,,,,'@,,    ',, ,''' ''',        
    @@@@@@@@@@@',  ', ,'@@@@@''''@@'@@ @@ @'',,,,,,'',     ,'''@',,   ',,,      ,,,     ,,,
    @@@@@@@@@@@@''''  ,'@@@@''''''@@@@','@ '',,,''''''',, ,  ,'',,,,, '',,        '    ,,,'
    @@@@@@@@@@@@@@@,  ,'@@@@''''',',,,,,''''', '','@@@@@@@''','',,,,,'@@''      ,,',,   ,''
    @@@@@@@@@@@@@@@''  ,@@@@''''',,,,,,,'''',,,''''''@@@@@@@''',,,,,'''@@@''',,,,''',  ,'@'
    @@@@@@@@@@@@@@'@@,'' ,,@@'''',,,,,,,'''',,''',,,''@@@@'''  ,,,,,'''''''@,,,''''','', ''
    @@@@@@@@@@@@@@@@@@@@'','@'''',,,,,''''',,''',,,,,,,,,,,,       @','''''@@''''@@@@@@@''@
    @@@@@@@@@@@@@@@@@@@@'','@'''',,,,@'''',,,''',,,,,,,,,,,,     ,@@@'''@''@@'@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@'@@'' '''''',,,,'''@''@@'',,,,,,,'''''     '@@''@',  ' ,'@@@@@@@@@@@@
    @@@@@@@@@@@@'''@@@@@@@@,, '''','''',,,,,,'',,,,,'''''''@,,   '''''''  '  ,'@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@',,''''@@@@',,,,,,,,,'''''''''@@, ,  ,,'''',',   '@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@'@'',,'@@@@@@@@@@@,,,'''''''''''@@@,,,   ,'@@'',   @@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@'@@',,'@@'''@@@@@@@''''''''''''@@@@',  ,  '@'''  @@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@''@'',,@@@@'''''''@'''''''''''@@@@@@@@',,,'@'''@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@'@@,'''@'',,,@@@@@@@@@@''''''''''@@@@@'@@@@@',,'''',  @@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@ @''@'',,,''''''''''''''''@@@@@',,,,  @@'',,@@    ,@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@'@'''@'',,,'''''''''''@@@@@@@@''',,    '',,@@@@' ''''@@@@@@@@@@@@@
    @@@@@@@@@@@'''@@@@@@@@'''''''',,,,''''''@@@@@@@@@@@@'''',,,,', @@@@@@@@@@'@@@@@@@@@@@@@
    @@@@@@@@@'@@@@''@@@@@@''''''''',,,'@@@@@@@''@@@@@@@,', , ,',  @@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@'@''''''''',,,@@@@'''''@@@@@@@@',    '@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@'@@ @@@@@@@@'@'''''''''',,,'''''''''@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@''''''''@'@@@@@@''''''''''',,,'''''''',@@@'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@'''''''''''@'@@@@@@@'''''''''',,,,''''''@,'@'@@''@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @''''''''''''''@@@@@@@'''''''''',,,,,   ' ',,@@@@'@''@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    '''''''''''''''@@@@@@@@'''''''',,,,,,    , ,','@@@@'''@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ''''''''''''''''@@@@@@@@''''''',,,,,,@ @, ,'' @ @@@@@''@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    '''''''''''''''''@@@@@@@'''''''',,,,'        @ ,'''@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    '''''''''''''''''''@@@@@@''''''',,,''',, ' @ '@,,''''@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    '''''''''''''''''''@@@@@@'''''''''''''''  , @ ,  '''''@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
RuPol is a glamorous mixin for instance pooling your Ruby classes. 

It eases the pain of garbarge collection for classes that are instantiated many times, and then tossed away like runway trash. Instances are cached on the class in a pool (array, in less glamorous terms), and can be recycled at will. Of course, there is no pain without gain, and models will trade collection costs for memory usages. The Swimsuit mixin edition overrides #new and #destroy, for a virtually pain free instance swimming experience.
  
Runway not included.

Usage
--------

The RuPol module can just be included into your class:

    class MyModel 
      include RuPol
    
      def self.process
        instance = rehydrate || new
        # .... do something with the instance
        instance.recycle
      end
    end

Instance convenience methods added to the class will be:

* #recycle - This will clear your instance, provided a #clear method exists, and then stash it in the instance pool

Class methods added for convenience include:

* #max&#95;pool_size - Can be used after including the module in order to configure the size limit on the pool
* #empty_pool - Clears the pool and related stats
* #rehydrade - Get an instance from the pool and initialize it with arguments

Including the RuPol module itself means that you do all the heavy lifting of using the pool. If you want coding life a little simpler, then use the RuPol::Swimsuit edition module instead. It overrides #new and #destroy, so that you can just use the pool in the normal lifecycle of an object.

    class MyLazyModel
      include RuPol::Swimsuit
    end
    
    instance = MyLazyModel.new    # this could be a recycled or a new instance depending on what's in your pool
    instance.destroy   # goes back into the pool, and if your superclass defines #destroy, that gets called first!

The Swimsuit edition provides a #clear method too so that your large objects get cleaned out before storage. Plus all the benefits of more rigorous pool usage.

Contributing to ru_pol
--------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
--------

Copyright (c) 2011 Kane Baccigalupi. See LICENSE.txt for
further details.

