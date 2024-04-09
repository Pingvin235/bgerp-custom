package org.bgerp.plugin.custom.demo;

import org.bgerp.app.event.iface.Event;
import org.bgerp.app.event.iface.EventListener;
import org.bgerp.util.Log;

import ru.bgcrm.event.RunClassRequestEvent;
import ru.bgcrm.util.sql.ConnectionSet;

/**
 * Demo class to be called via HTTP request.
 * http://[host]:[port]/admin/run.do?action=runClass&iface=event&class=org.bgerp.plugin.custom.demo.DemoNotifyClass&j_username=[user]&j_password=[pswd]&param1=value1
 */
public class DemoNotifyClass implements EventListener<Event> {
    private static final Log log = Log.getLog();

    @Override
    public void notify(Event e, ConnectionSet connectionSet) throws Exception {
        RunClassRequestEvent event = (RunClassRequestEvent) e;

        String param1 = event.getForm().getParam("param1");
        log.info("Got request with param1={}", param1);

        // send in response the current user object
        event.getForm().setResponseData("user", event.getUser());
    }
}
