package org.bgerp.plugin.custom.demo.action.report;

import org.apache.struts.action.ActionForward;
import org.bgerp.plugin.custom.demo.Plugin;
import org.bgerp.plugin.report.action.ReportActionBase;
import org.bgerp.plugin.report.model.Column;
import org.bgerp.plugin.report.model.Columns;
import org.bgerp.plugin.report.model.Data;

import ru.bgcrm.servlet.ActionServlet.Action;
import ru.bgcrm.struts.form.DynActionForm;
import ru.bgcrm.util.sql.ConnectionSet;

@Action(path = "/user/plugin/custom.demo/report/demo")
public class DemoReport extends ReportActionBase {
    /**
     * This overwritten method is required because of action specification.
     */
    @Override
    public ActionForward unspecified(DynActionForm form, ConnectionSet conSet) throws Exception {
        return super.unspecified(form, conSet);
    }

    @Override
    public String getTitle() {
        // the title is localized in the plugin's l10n.xml
        return "Demo Report";
    }

    @Override
    protected String getHref() {
        // URL suffix for 'user' interface
        // TODO: must be "report/custom.demo/demo", but not handled properly on frontend
        return "report/custom/demo/demo";
    }

    private static final Column COL_ID = new Column.ColumnInteger("id", "ID", null);
    private static final Column COL_DESCRIPTION = new Column.ColumnString("description", null, "Описание");

    private static final Columns COLUMNS = new Columns(
        COL_ID,
        COL_DESCRIPTION
    );

    @Override
    public Columns getColumns() {
        return COLUMNS;
    }

    @Override
    protected String getJsp() {
        return Plugin.PATH_JSP_USER + "/report/demo.jsp";
    }

    @Override
    protected Selector getSelector() {
        return new Selector() {
            @Override
            protected void select(ConnectionSet conSet, Data data) throws Exception {
                /* final var form = data.getForm();

                final var dateFrom = form.getParamDate("dateFrom", new Date(), true);
                final var dateTo = form.getParamDate("dateTo", new Date(), true);

                final var type = form.getParam("type", "create", true, null);
                if (!StringUtils.equalsAny(type, "create", "close"))
                    throw new BGIllegalArgumentException();

                final var pd = new PreparedDelay(conSet.getSlaveConnection());
                pd.addQuery(SQL_SELECT_COUNT_ROWS + " id, type_id, " + type + "_user_id, " + type + "_dt, description " + SQL_FROM + Tables.TABLE_PROCESS);
                pd.addQuery(SQL_WHERE);
                pd.addQuery(type + "_dt");
                pd.addQuery(" BETWEEN ? AND ?");
                pd.addDate(dateFrom);
                pd.addDate(TimeUtils.getNextDay(dateTo));
                pd.addQuery(SQL_ORDER_BY);
                pd.addQuery(type + "_dt");

                var rs = pd.executeQuery();
                while (rs.next()) {
                    final var r = data.addRecord();
                    r.add(rs.getInt(r.pos()));
                    r.add(ProcessTypeCache.getProcessType(rs.getInt(r.pos())).getTitle());
                    final int userId = rs.getInt(r.pos());
                    r.add(userId);
                    r.add(UserCache.getUser(userId).getTitle());
                    r.add(rs.getTimestamp(r.pos()));
                    r.add(rs.getString(r.pos()));
                }

                setRecordCount(form.getPage(), pd.getPrepared()); */
            }
        };
    }
}

