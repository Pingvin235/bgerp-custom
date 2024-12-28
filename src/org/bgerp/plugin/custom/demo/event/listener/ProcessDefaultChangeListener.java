package org.bgerp.plugin.custom.demo.event.listener;

import org.bgerp.app.event.iface.EventListener;
import org.bgerp.app.exception.BGMessageExceptionWithoutL10n;
import org.bgerp.event.base.UserEvent;

import ru.bgcrm.event.process.ProcessChangingEvent;
import ru.bgcrm.util.sql.ConnectionSet;

public class ProcessDefaultChangeListener implements EventListener<UserEvent> {
    @Override
    public void notify(UserEvent e, ConnectionSet conSet) throws Exception {
        // processing only a single event type
        if (!(e instanceof ProcessChangingEvent event) || !event.isStatus())
            return;

        final String token = "BLI";

        if (!event.getProcess().getDescription().contains(token))
            throw new BGMessageExceptionWithoutL10n("For changing status the process' description must contain substring '{}'", token);
    }
}
