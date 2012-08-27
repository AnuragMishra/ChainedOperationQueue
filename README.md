ChainedOperationQueue
=====================

This minimal example shows how to create multiple asynchronous operations using the `NSOperation` and `NSOperationQueue` classes and specify dependencies between them. Defining dependencies between operations is a very powerful way of doing various tasks which have some sort of inherent ordering built-in, and could potentially take a large and unknown amount of time. Here are just a few examples:

- Download an image from the web, and then convert it into another format locally.
- Drive to the theater, then buy tickets to a movie, then walk inside the theater, take a seat, and enjoy the show.

The basic idea is that you need to do these things in order. The next step can only proceed if the previous step completes successfully (in most cases). For example, you can't walk inside a theater without buying a ticket. Likewise you can't watch the movie unless you go inside the theater and so on.

So how would you model this in code, you ask?

Simple. For each operation/task that needs to happen, create a subclass of `NSOperation`, or use one of its existing subclasses like `NSBlockOperation` or `NSInvocationOperation` if you don't want fine-grained control.

    DownloadImageOperation *downloadImage = [[DownloadImageOperation alloc] init];
    ConvertImageOperation *convertImage = [[ConvertImageOperation alloc] init];

Define the dependencies between the operations using the `addDependency:` method of `NSOperation`.

    [convertImage addDependency:downloadImage];

Then, add all operations to a `NSOperationQueue` and watch it run.

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:[NSArray arrayWithObjects:downloadImage, convertImage, nil] waitUntilFinished:NO];

And that is it!