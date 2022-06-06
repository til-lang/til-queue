import til.commands;
import til.nodes;

import queue;


extern (C) CommandsMap getCommands(Escopo escopo)
{
    CommandsMap commands;

    commands[null] = new Command((string path, Context context)
    {
        ulong size = 64;
        if (context.size > 0)
        {
            size = context.pop!ulong();
        }
        auto queue = new Queue(size);

        return context.push(queue);
    });
    queueCommands["push"] = new Command((string path, Context context)
    {
        auto queue = context.pop!Queue();

        foreach(argument; context.items)
        {
            if (queue.isFull)
            {
                auto msg = "queue is full";
                return context.error(msg, ErrorCode.Full, "");
            }
            queue.push(argument);
        }

        return context;
    });
    queueCommands["pop"] = new Command((string path, Context context)
    {
        auto queue = context.pop!Queue();
        long howMany = 1;
        if (context.size > 0)
        {
            howMany = cast(int)context.pop!long();
        }
        foreach(idx; 0..howMany)
        {
            if (queue.isEmpty)
            {
                auto msg = "queue is empty";
                return context.error(msg, ErrorCode.Empty, "");
            }
            context.push(queue.pop());
        }

        return context;
    });
    queueCommands["send"] = new Command((string path, Context context)
    {
        auto queue = context.pop!Queue();

        foreach (target; context.items)
        {
            auto nextContext = context;
            while (true)
            {
                nextContext = target.next(context);
                if (nextContext.exitCode == ExitCode.Break)
                {
                    break;
                }
                auto item = nextContext.pop();
                if (queue.isFull)
                {
                    auto msg = "queue is full";
                    return context.error(msg, ErrorCode.Full, "");
                }
                queue.push(item);
            }
        }

        return context;
    });
    queueCommands["receive"] = new Command((string path, Context context)
    {
        if (context.size != 1)
        {
            auto msg = "`" ~ path ~ "` expects one argument";
            return context.error(msg, ErrorCode.InvalidArgument, "");
        }

        auto queue = context.pop!Queue();
        return context.push(queue);
    });
    queueCommands["length"] = new Command((string path, Context context)
    {
        auto queue = context.pop!Queue();
        return context.push(queue.values.length);
    });

    return commands;
}
