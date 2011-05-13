[% PROCESS svc_util.t -%]
// [% pkg %]_manifest.cpp   -*-C++-*-

#include <bdes_ident.h>
BDES_IDENT_RCSID([% pkg %]_manifest_cpp,"\$Id\$ \$CSID\$ \$CCId\$")

#include <[% pkg %]_manifest.h>

namespace BloombergLP {
namespace [% namespace %] {

                               // --------------
                               // class Manifest
                               // --------------

// CLASS DATA

const char *Manifest::d_name_p            = "[% SERVICE %]";
const char *Manifest::d_description_p     =
           "TODO: Provide description for [% SERVICE %]";
const int   Manifest::d_majorVersion      = [% svc.serviceVersionMajor %];
const int   Manifest::d_minorVersion      = [% svc.serviceVersionMinor %];
const char *Manifest::d_schemaNamespace_p =
           "[% svc.targetNamespace %]";
const char *Manifest::d_requestElement_p  = "[% svc.requestElement %]";
const char *Manifest::d_responseElement_p = "[% svc.responseElement %]";

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