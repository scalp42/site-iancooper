# Attachments in VGL

Often, we'll want to attach a document to a particular SampleManager entity.  This functionality isn't included in SampleManager by default, but we can add it through VGL.  There are many different ways to accomplish this; the specific goals of my implementation here are:

 1. the ability to associate files with any SampleManager entity,
 2. the files should be stored in the filesystem rather than as database blobs,
 3. the files should be able to be viewed or launched directly from the SampleManager client application