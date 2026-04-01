(function(){
  function generateId(){
    const arr=new Uint8Array(16);crypto.getRandomValues(arr);
    return Array.from(arr,b=>b.toString(16).padStart(2,'0')).join('');
  }
  function toNanoTime(d){return Math.floor(d*1e6)*1e3;}
  function sendTrace(spans){
    const body={resourceSpans:[{resource:{attributes:[{key:'service.name',value:{stringValue:'check-2-check-web'}}]},scopeSpans:[{spans}]}]};
    fetch('/api/traces',{
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body:JSON.stringify(body),
    }).catch(()=>{});
  }
  const traceId=generateId();
  const spans=[];
  const loadStart=performance.timing.navigationStart;
  const loadEnd=performance.timing.loadEventEnd||Date.now();
  spans.push({
    traceId,spanId:generateId(),name:'document_load',
    kind:1,
    startTimeUnixNano:toNanoTime(loadStart),
    endTimeUnixNano:toNanoTime(loadEnd),
    attributes:[{key:'url',value:{stringValue:location.href}}],
    status:{code:1},
  });
  window.addEventListener('load',()=>{
    setTimeout(()=>{if(spans.length)sendTrace(spans);},1000);
  });
  const origFetch=window.fetch;
  window.fetch=function(...args){
    const spanId=generateId();
    const start=performance.now();
    const url=args[0]&&args[0].toString?args[0].toString():String(args[0]);
    const method=args[1]&&args[1].method?args[1].method:'GET';
    const p=origFetch.apply(this,args);
    p.then(r=>{
      const end=performance.now();
      spans.push({
        traceId,spanId,name:`${method} ${url}`,
        kind:2,
        startTimeUnixNano:toNanoTime(performance.timing.navigationStart+start),
        endTimeUnixNano:toNanoTime(performance.timing.navigationStart+end),
        attributes:[
          {key:'http.method',value:{stringValue:method}},
          {key:'http.url',value:{stringValue:url}},
          {key:'http.status_code',value:{intValue:r.status}},
        ],
        status:{code:r.ok?1:2},
      });
      sendTrace(spans.splice(0,spans.length));
    }).catch(()=>{
      spans.push({
        traceId,spanId,name:`${method} ${url}`,
        kind:2,
        startTimeUnixNano:toNanoTime(performance.timing.navigationStart+start),
        endTimeUnixNano:toNanoTime(Date.now()),
        attributes:[
          {key:'http.method',value:{stringValue:method}},
          {key:'http.url',value:{stringValue:url}},
        ],
        status:{code:2,description:'fetch error'},
      });
      sendTrace(spans.splice(0,spans.length));
    });
    return p;
  };
  document.addEventListener('click',function(e){
    const target=e.target.closest('button,[role=button],a')||e.target;
    const name=target.textContent?target.textContent.trim().substring(0,50):target.tagName.toLowerCase();
    if(!name)return;
    const spanId=generateId();
    const start=performance.now();
    setTimeout(()=>{
      spans.push({
        traceId,spanId,name:`click: ${name}`,
        kind:3,
        startTimeUnixNano:toNanoTime(performance.timing.navigationStart+start),
        endTimeUnixNano:toNanoTime(performance.timing.navigationStart+start+1),
        attributes:[{key:'ui.action',value:{stringValue:'click'}},{key:'ui.target',value:{stringValue:name}}],
        status:{code:1},
      });
      sendTrace(spans.splice(0,spans.length));
    },100);
  });
})();
