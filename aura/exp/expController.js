({
    doInit : function(component) {
        var sessionId = component.get("v.sessionId");
        var action = component.get("c.serverEcho");
        console.log('sessionId da exp->',sessionId);
        action.setParams({ sessionId : sessionId });
        $A.enqueueAction(action);
    }
})
