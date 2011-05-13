[% PROCESS svc_util.t -%]
// [% pkg %]_requestprocessor.cpp   -*-C++-*-

#include <bdes_ident.h>
BDES_IDENT_RCSID([% pkg %]_requestprocessor_cpp,"\$Id\$ \$CSID\$ \$CCId\$")

#include <[% pkg %]_requestprocessor.h>

#include <[% pkg %]_requestcontext.h>
#include <[% pkg %]_manifest.h>
[% UNLESS opts.noSchema -%]
[% IF pkg != msgpkg -%]

[% END -%]
[% IF opts.msgExpand -%]
#include <[% msgpkg %]_[% requesttype %].h>
#include <[% msgpkg %]_[% responsetype %].h>
[% ELSE -%]
#include <[% msgpkg %]_[% opts.msgComponent %].h>
[% END -%]

[% END -%]
#include <bascfg_configutil.h>
#include <bassvc_requestprocessor.h>
#include <basm_metrics.h>

#include <bsct_errorinfo.h>

#include <bael_log.h>
#include <baem_metrics.h>

#include <bsls_assert.h>

namespace BloombergLP {
namespace [% namespace %] {

namespace {

const char LOG_CATEGORY[] = "[% SERVICE %].REQUESTPROCESSOR";

}  // close unnamed namespace

                           // ----------------------
                           // class RequestProcessor
                           // ----------------------

// CREATORS

RequestProcessor::RequestProcessor(
        const bcem_Aggregate&  configuration,
        bslma_Allocator       *basicAllocator)
: d_allocator_p(bslma_Default::allocator(basicAllocator))
, d_configuration(configuration)
, d_metricsCategory(basicAllocator)
{
    BAEL_LOG_SET_CATEGORY(LOG_CATEGORY);

    bcem_Aggregate serviceId =
        bascfg::ConfigUtil::findServiceId(configuration);
    d_metricsCategory.assign(serviceId.asString()).append("-APP");
    BSLS_ASSERT(!serviceId.isError());
}

RequestProcessor::RequestProcessor(
        const bsl::string&     serviceName,
        const bcem_Aggregate&  configuration,
        bslma_Allocator       *basicAllocator)
: d_allocator_p(bslma_Default::allocator(basicAllocator))
, d_configuration(configuration)
, d_metricsCategory(basicAllocator)
{
    BAEL_LOG_SET_CATEGORY(LOG_CATEGORY);

    bcem_Aggregate serviceId =
        bascfg::ConfigUtil::findServiceId(configuration, serviceName);
    d_metricsCategory.assign(serviceId.asString()).append("-APP");
    BSLS_ASSERT(!serviceId.isError());
}

RequestProcessor::~RequestProcessor()
{
    BAEL_LOG_SET_CATEGORY(LOG_CATEGORY);
}

// MANIPULATORS

// ------ CHANGE ONLY THE FUNCTION IMPLEMENTATIONS IN THE FOLLOWING CODE ------

void RequestProcessor::processControlEvent(
        const bassvc::RequestProcessorControlEvent& event)
{
    BAEL_LOG_SET_CATEGORY(LOG_CATEGORY);

    typedef bassvc::RequestProcessorControlEvent Event;

    switch (event.eventType()) {
      case Event::START: {
        // The service is starting.  At this point, no requests can be
        // forwarded to the request processor yet.

      }  break;
      case Event::READY: {
        // The service is starting.  The request processor is able to receive
        // requests (and might already have).

      }  break;
      case Event::STOP: {
        // The service is stopping.  No more requests will be forwarded to the
        // request processor.  At this point, the request processor must
        // release any request contexts or request objects that it might be
        // holding.

      }  break;
      case Event::RECONFIGURE: {
        // un-used for now
      }  break;
    }
}

[% IF opts.noSchema -%]
void RequestProcessor::processRequest(
        bdema_ManagedPtr<bcema_Blob>&     request,
        bdema_ManagedPtr<RequestContext>& context)
{
    BAEL_LOG_SET_CATEGORY(LOG_CATEGORY);

    //
    // TBD: Create an appropriate response object, and deliver it using the
    // specified 'context'.
    //

}

[% ELSIF 0 == svc.numRequests -%]
void RequestProcessor::processRequest(
        bdema_ManagedPtr<[% MSGNS %][% RequestType %]>& request,
        bdema_ManagedPtr<RequestContext>& context)
{
    BAEL_LOG_SET_CATEGORY(LOG_CATEGORY);

    //
    // TBD: Create an appropriate response object, and deliver it using the
    // specified 'context'.
    //

}

[% ELSE -%]
[% FOREACH request = svc.requests -%]
void RequestProcessor::process[% request.name %](
[% IF request.noNamespaceFlag -%]
[% IF request.isPrimitiveFlag -%]
[% SET offlen = request.type.length -%]
[% SET offlen = 33 - offlen -%]
[% SET offset = String.new(' ').repeat(offlen) -%]
        [% request.type %] [% offset %][% request.argumentName %],
[% ELSE -%]
        bdema_ManagedPtr<[% request.type %][% -%]
        [%- request.isVectorFlag ? ' ' : '' -%]
        [%- %]>& [% request.argumentName %],
[% END -%]
[% ELSE -%]
        bdema_ManagedPtr<[% MSGNS %][% request.type %]>& [% -%]
        [%- request.argumentName %],
[% END -%]
        bdema_ManagedPtr<RequestContext>& context)
{
    BAEL_LOG_SET_CATEGORY(LOG_CATEGORY);

    //
    // TBD: Create an appropriate response object, and deliver it using the
    // specified 'context'.
    //

}

[% END -%]
[% END -%]
}  // close namespace [% namespace %]
}  // close namespace BloombergLP

// GENERATED BY [% version %] [% timestamp %]
// ----------------------------------------------------------------------------
// NOTICE:
//      Copyright (C) Bloomberg L.P., [% year.format %]
//      All Rights Reserved.
//      Property of Bloomberg L.P. (BLP)
//      This software is made available solely pursuant to the
//      terms of a BLP license agreement which governs its use.
// ------------------------------- END-OF-FILE --------------------------------